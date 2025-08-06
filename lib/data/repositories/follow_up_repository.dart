import '../models/follow_up_model.dart';
import '../../core/services/api_service.dart';

class FollowUpRepository {
  final ApiService _apiService = ApiService();

  Future<List<FollowUpModel>> getFollowUps() async {
    try {
      final response = await _apiService.get('/one-to-one-follow-ups');

      if (response['success'] == true) {
        final List<dynamic> followUpsData = response['data'];
        return followUpsData
            .map((json) => FollowUpModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response['message'] ?? 'Error al cargar seguimientos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<FollowUpModel> createFollowUp({
    required int meetingId,
    required DateTime followUpDate,
    String? followUpNotes,
    String? actionItems,
  }) async {
    try {
      final response = await _apiService.post('/one-to-one-follow-ups', data: {
        'meeting_id': meetingId,
        'follow_up_date': followUpDate.toIso8601String(),
        'follow_up_notes': followUpNotes,
        'action_items': actionItems,
      });

      if (response['success'] == true) {
        return FollowUpModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al crear seguimiento');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<FollowUpModel> updateFollowUpStatus(
    int followUpId,
    String status,
    String? notes,
  ) async {
    try {
      final response = await _apiService
          .put('/one-to-one-follow-ups/$followUpId/status', data: {
        'status': status,
        'follow_up_notes': notes,
      });

      if (response['success'] == true) {
        return FollowUpModel.fromJson(response['data']);
      } else {
        throw Exception(
            response['message'] ?? 'Error al actualizar seguimiento');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<FollowUpModel> updateFollowUp({
    required int followUpId,
    DateTime? followUpDate,
    String? followUpNotes,
    String? actionItems,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (followUpDate != null) {
        data['follow_up_date'] = followUpDate.toIso8601String();
      }
      if (followUpNotes != null) {
        data['follow_up_notes'] = followUpNotes;
      }
      if (actionItems != null) {
        data['action_items'] = actionItems;
      }

      final response = await _apiService
          .put('/one-to-one-follow-ups/$followUpId', data: data);

      if (response['success'] == true) {
        return FollowUpModel.fromJson(response['data']);
      } else {
        throw Exception(
            response['message'] ?? 'Error al actualizar seguimiento');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> deleteFollowUp(int followUpId) async {
    try {
      final response =
          await _apiService.delete('/one-to-one-follow-ups/$followUpId');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Error al eliminar seguimiento');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
