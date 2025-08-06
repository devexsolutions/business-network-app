import '../models/recommendation_model.dart';
import '../../core/services/api_service.dart';

class RecommendationRepository {
  final ApiService _apiService = ApiService();

  Future<List<RecommendationModel>> getSentRecommendations() async {
    try {
      final response = await _apiService.get('/business-recommendations/sent');

      if (response['success'] == true) {
        final List<dynamic> recommendationsData = response['data'];
        return recommendationsData
            .map((json) => RecommendationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            response['message'] ?? 'Error al cargar recomendaciones enviadas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<RecommendationModel>> getReceivedRecommendations() async {
    try {
      final response =
          await _apiService.get('/business-recommendations/received');

      if (response['success'] == true) {
        final List<dynamic> recommendationsData = response['data'];
        return recommendationsData
            .map((json) => RecommendationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
            response['message'] ?? 'Error al cargar recomendaciones recibidas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<RecommendationModel> createRecommendation({
    required int recommenderId,
    required int recommendeeId,
    String? description,
  }) async {
    try {
      final response =
          await _apiService.post('/business-recommendations', data: {
        'recommender_id': recommenderId,
        'recommendee_id': recommendeeId,
        'description': description,
      });

      if (response['success'] == true) {
        return RecommendationModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al crear recomendación');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<RecommendationModel> updateRecommendationStatus(
    int recommendationId,
    String status,
  ) async {
    try {
      final response = await _apiService
          .put('/business-recommendations/$recommendationId', data: {
        'status': status,
      });

      if (response['success'] == true) {
        return RecommendationModel.fromJson(response['data']);
      } else {
        throw Exception(
            response['message'] ?? 'Error al actualizar recomendación');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> deleteRecommendation(int recommendationId) async {
    try {
      final response = await _apiService
          .delete('/business-recommendations/$recommendationId');

      if (response['success'] != true) {
        throw Exception(
            response['message'] ?? 'Error al eliminar recomendación');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
