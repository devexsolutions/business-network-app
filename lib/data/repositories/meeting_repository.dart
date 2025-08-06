import '../models/meeting_model.dart';
import '../../core/services/api_service.dart';

class MeetingRepository {
  final ApiService _apiService = ApiService();

  Future<List<MeetingModel>> getMeetings() async {
    try {
      final response = await _apiService.get('/one-to-one-meetings');

      if (response['success'] == true) {
        final List<dynamic> meetingsData = response['data'];
        return meetingsData.map((json) => MeetingModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Error al cargar reuniones');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<MeetingModel> createMeeting({
    required int participantId,
    required String whoProposed,
    required DateTime meetingDate,
    String? location,
    String? topicsDiscussed,
  }) async {
    try {
      final response = await _apiService.post('/one-to-one-meetings', data: {
        'participant_id': participantId,
        'who_proposed': whoProposed,
        'meeting_date': meetingDate.toIso8601String(),
        'location': location,
        'topics_discussed': topicsDiscussed,
      });

      if (response['success'] == true) {
        return MeetingModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al crear reunión');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<MeetingModel> updateMeeting({
    required int meetingId,
    int? participantId,
    String? whoProposed,
    DateTime? meetingDate,
    String? location,
    String? topicsDiscussed,
  }) async {
    try {
      final Map<String, dynamic> data = {};

      if (participantId != null) {
        data['participant_id'] = participantId;
      }
      if (whoProposed != null) {
        data['who_proposed'] = whoProposed;
      }
      if (meetingDate != null) {
        data['meeting_date'] = meetingDate.toIso8601String();
      }
      if (location != null) {
        data['location'] = location;
      }
      if (topicsDiscussed != null) {
        data['topics_discussed'] = topicsDiscussed;
      }

      final response =
          await _apiService.put('/one-to-one-meetings/$meetingId', data: data);

      if (response['success'] == true) {
        return MeetingModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al actualizar reunión');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> deleteMeeting(int meetingId) async {
    try {
      final response =
          await _apiService.delete('/one-to-one-meetings/$meetingId');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Error al eliminar reunión');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
