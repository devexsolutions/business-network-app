import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/api_service.dart';
import '../models/post_model.dart';

class PostRepository {
  final ApiService _apiService = ApiService();

  Future<List<Post>> getPosts({
    int page = 1,
    String? feed,
    String? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
      };

      if (feed != null) queryParams['feed'] = feed;
      if (type != null) queryParams['type'] = type;

      final response = await _apiService.get(
        ApiConstants.posts,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response['data'];
      return data.map((json) => Post.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Post> getPost(int id) async {
    try {
      final response = await _apiService.get('${ApiConstants.posts}/$id');
      return Post.fromJson(response['post']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Post> createPost(CreatePostRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.posts,
        data: request.toJson(),
      );

      return Post.fromJson(response['post']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Post> updatePost(int id, CreatePostRequest request) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.posts}/$id',
        data: request.toJson(),
      );

      return Post.fromJson(response['post']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await _apiService.delete('${ApiConstants.posts}/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> toggleLike(int id) async {
    try {
      final response =
          await _apiService.post('${ApiConstants.posts}/$id/like', data: {});
      return {
        'liked': response['liked'],
        'likes_count': response['likes_count'],
      };
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

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
            return 'No tienes permisos para realizar esta acción.';
          case 403:
            return 'Acceso denegado.';
          case 404:
            return 'Post no encontrado.';
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
