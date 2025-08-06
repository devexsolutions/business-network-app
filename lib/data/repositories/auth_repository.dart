import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/api_service.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Login
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);

      // Guardar token y usuario
      await _storage.write(
          key: AppConstants.tokenKey, value: authResponse.token);
      await _storage.write(
          key: AppConstants.userKey,
          value: authResponse.user.toJson().toString());

      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Register
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);

      // Guardar token y usuario
      await _storage.write(
          key: AppConstants.tokenKey, value: authResponse.token);
      await _storage.write(
          key: AppConstants.userKey,
          value: authResponse.user.toJson().toString());

      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConstants.logout);
    } catch (e) {
      // Continuar con logout local aunque falle el servidor
    } finally {
      // Limpiar storage local
      await _storage.delete(key: AppConstants.tokenKey);
      await _storage.delete(key: AppConstants.userKey);
    }
  }

  // Get current user
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiConstants.me);
      return User.fromJson(response['user']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: AppConstants.tokenKey);
    return token != null;
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  // Get stored user
  Future<User?> getStoredUser() async {
    final userJson = await _storage.read(key: AppConstants.userKey);
    if (userJson != null) {
      try {
        // Aquí necesitarías parsear el JSON string de vuelta a Map
        // Por simplicidad, mejor hacer una llamada a getCurrentUser()
        return await getCurrentUser();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Get profile stats
  Future<ProfileStats> getProfileStats() async {
    try {
      final response = await _apiService.get(ApiConstants.profileStats);
      return ProfileStats.fromJson(response['stats']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle Dio errors
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de conexión agotado. Verifica tu conexión a internet.';

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'];

        switch (statusCode) {
          case 400:
            return message ?? 'Solicitud incorrecta.';
          case 401:
            return 'Credenciales incorrectas.';
          case 403:
            return 'No tienes permisos para realizar esta acción.';
          case 404:
            return 'Recurso no encontrado.';
          case 422:
            return message ?? 'Datos de entrada inválidos.';
          case 500:
            return 'Error interno del servidor.';
          default:
            return message ?? 'Error desconocido del servidor.';
        }

      case DioExceptionType.cancel:
        return 'Solicitud cancelada.';

      case DioExceptionType.unknown:
      default:
        return 'Error de conexión. Verifica tu conexión a internet.';
    }
  }
}
