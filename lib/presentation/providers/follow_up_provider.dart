import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/follow_up_model.dart';
import '../../data/repositories/follow_up_repository.dart';

final followUpRepositoryProvider = Provider<FollowUpRepository>((ref) {
  return FollowUpRepository();
});

final followUpProvider =
    StateNotifierProvider<FollowUpNotifier, FollowUpState>((ref) {
  return FollowUpNotifier(ref.read(followUpRepositoryProvider));
});

class FollowUpState {
  final List<FollowUpModel> followUps;
  final bool isLoading;
  final String? error;

  FollowUpState({
    this.followUps = const [],
    this.isLoading = false,
    this.error,
  });

  FollowUpState copyWith({
    List<FollowUpModel>? followUps,
    bool? isLoading,
    String? error,
  }) {
    return FollowUpState(
      followUps: followUps ?? this.followUps,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FollowUpNotifier extends StateNotifier<FollowUpState> {
  final FollowUpRepository _repository;

  FollowUpNotifier(this._repository) : super(FollowUpState());

  Future<void> loadFollowUps() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final followUps = await _repository.getFollowUps();
      state = state.copyWith(
        followUps: followUps,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createFollowUp({
    required int meetingId,
    required DateTime followUpDate,
    String? followUpNotes,
    String? actionItems,
  }) async {
    try {
      final followUp = await _repository.createFollowUp(
        meetingId: meetingId,
        followUpDate: followUpDate,
        followUpNotes: followUpNotes,
        actionItems: actionItems,
      );

      state = state.copyWith(
        followUps: [...state.followUps, followUp],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateFollowUpStatus(
    int followUpId,
    String status,
    String? notes,
  ) async {
    try {
      final updatedFollowUp = await _repository.updateFollowUpStatus(
        followUpId,
        status,
        notes,
      );

      final updatedFollowUps = state.followUps.map((f) {
        return f.id == followUpId ? updatedFollowUp : f;
      }).toList();

      state = state.copyWith(followUps: updatedFollowUps);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateFollowUp({
    required int followUpId,
    DateTime? followUpDate,
    String? followUpNotes,
    String? actionItems,
  }) async {
    try {
      final updatedFollowUp = await _repository.updateFollowUp(
        followUpId: followUpId,
        followUpDate: followUpDate,
        followUpNotes: followUpNotes,
        actionItems: actionItems,
      );

      final updatedFollowUps = state.followUps.map((f) {
        return f.id == followUpId ? updatedFollowUp : f;
      }).toList();

      state = state.copyWith(followUps: updatedFollowUps);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
