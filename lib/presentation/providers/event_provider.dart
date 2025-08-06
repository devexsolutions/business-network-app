import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier(ref.read(eventRepositoryProvider));
});

class EventState {
  final List<EventModel> events;
  final bool isLoading;
  final String? error;

  EventState({
    this.events = const [],
    this.isLoading = false,
    this.error,
  });

  EventState copyWith({
    List<EventModel>? events,
    bool? isLoading,
    String? error,
  }) {
    return EventState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EventNotifier extends StateNotifier<EventState> {
  final EventRepository _repository;

  EventNotifier(this._repository) : super(EventState());

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final events = await _repository.getEvents();
      state = state.copyWith(
        events: events,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createEvent({
    required String title,
    String? description,
    String? location,
    required DateTime eventDate,
    int? maxAttendees,
  }) async {
    try {
      final event = await _repository.createEvent(
        title: title,
        description: description,
        location: location,
        eventDate: eventDate,
        maxAttendees: maxAttendees,
      );

      state = state.copyWith(
        events: [...state.events, event],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> registerForEvent(int eventId) async {
    try {
      await _repository.registerForEvent(eventId);

      // Update the event in the list to show as registered
      final updatedEvents = state.events.map((event) {
        if (event.id == eventId) {
          return event.copyWith(isRegistered: true);
        }
        return event;
      }).toList();

      state = state.copyWith(events: updatedEvents);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> unregisterFromEvent(int eventId) async {
    try {
      await _repository.unregisterFromEvent(eventId);

      // Update the event in the list to show as not registered
      final updatedEvents = state.events.map((event) {
        if (event.id == eventId) {
          return event.copyWith(isRegistered: false);
        }
        return event;
      }).toList();

      state = state.copyWith(events: updatedEvents);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
