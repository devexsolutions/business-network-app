import '../models/event_model.dart';
import '../../core/services/api_service.dart';

class EventRepository {
  final ApiService _apiService = ApiService();

  Future<List<EventModel>> getEvents() async {
    try {
      final response = await _apiService.get('/events');

      if (response['success'] == true) {
        final List<dynamic> eventsData = response['data'];
        return eventsData.map((json) => EventModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Error al cargar eventos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<EventModel> createEvent({
    required String title,
    String? description,
    String? location,
    required DateTime eventDate,
    int? maxAttendees,
  }) async {
    try {
      final response = await _apiService.post('/events', data: {
        'title': title,
        'description': description,
        'location': location,
        'event_date': eventDate.toIso8601String(),
        'max_attendees': maxAttendees,
      });

      if (response['success'] == true) {
        return EventModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Error al crear evento');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> registerForEvent(int eventId) async {
    try {
      final response =
          await _apiService.post('/events/$eventId/register', data: {});

      if (response['success'] != true) {
        throw Exception(
            response['message'] ?? 'Error al registrarse en el evento');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> unregisterFromEvent(int eventId) async {
    try {
      final response = await _apiService.delete('/events/$eventId/unregister');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Error al cancelar registro');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<EventModel>> getMyEvents() async {
    try {
      final response = await _apiService.get('/events/my-events');

      if (response['success'] == true) {
        final List<dynamic> eventsData = response['data'];
        return eventsData.map((json) => EventModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Error al cargar mis eventos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
