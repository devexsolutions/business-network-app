import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  final _logger = Logger();

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
      headers: {
        'Content-Type': ApiConstants.contentType,
        'Accept': ApiConstants.contentType,
      },
    ));

    // Interceptor para logs
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => _logger.d(object),
    ));

    // Interceptor para autenticación
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.tokenKey);
        if (token != null) {
          options.headers[ApiConstants.authorization] =
              '${ApiConstants.bearer} $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expirado, limpiar storage
          await _storage.delete(key: AppConstants.tokenKey);
          await _storage.delete(key: AppConstants.userKey);
          // Aquí podrías navegar al login
        }
        handler.next(error);
      },
    ));
  }

  // Métodos de conveniencia que devuelven Response
  Future<Response> getRaw(String path,
      {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> postRaw(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> putRaw(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> deleteRaw(String path) {
    return _dio.delete(path);
  }

  // Métodos que devuelven Map<String, dynamic> para los repositorios
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> post(String path, {dynamic data}) async {
    final response = await _dio.post(path, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> put(String path, {dynamic data}) async {
    final response = await _dio.put(path, data: data);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete(path);
    return response.data as Map<String, dynamic>;
  }

  // Upload de archivos
  Future<Response> uploadFile(String path, String filePath, String fieldName) {
    final formData = FormData.fromMap({
      fieldName: MultipartFile.fromFileSync(filePath),
    });
    return _dio.post(path, data: formData);
  }
}
