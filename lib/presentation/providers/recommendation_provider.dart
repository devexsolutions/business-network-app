import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/recommendation_model.dart';
import '../../data/repositories/recommendation_repository.dart';

final recommendationRepositoryProvider =
    Provider<RecommendationRepository>((ref) {
  return RecommendationRepository();
});

final recommendationProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>((ref) {
  return RecommendationNotifier(ref.read(recommendationRepositoryProvider));
});

class RecommendationState {
  final List<RecommendationModel> sentRecommendations;
  final List<RecommendationModel> receivedRecommendations;
  final bool isLoading;
  final String? error;

  RecommendationState({
    this.sentRecommendations = const [],
    this.receivedRecommendations = const [],
    this.isLoading = false,
    this.error,
  });

  RecommendationState copyWith({
    List<RecommendationModel>? sentRecommendations,
    List<RecommendationModel>? receivedRecommendations,
    bool? isLoading,
    String? error,
  }) {
    return RecommendationState(
      sentRecommendations: sentRecommendations ?? this.sentRecommendations,
      receivedRecommendations:
          receivedRecommendations ?? this.receivedRecommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  final RecommendationRepository _repository;

  RecommendationNotifier(this._repository) : super(RecommendationState());

  Future<void> loadRecommendations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final sent = await _repository.getSentRecommendations();
      final received = await _repository.getReceivedRecommendations();

      state = state.copyWith(
        sentRecommendations: sent,
        receivedRecommendations: received,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createRecommendation({
    required int recommenderId,
    required int recommendeeId,
    String? description,
  }) async {
    try {
      final recommendation = await _repository.createRecommendation(
        recommenderId: recommenderId,
        recommendeeId: recommendeeId,
        description: description,
      );

      state = state.copyWith(
        sentRecommendations: [...state.sentRecommendations, recommendation],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateRecommendationStatus(
      int recommendationId, String status) async {
    try {
      final updatedRecommendation =
          await _repository.updateRecommendationStatus(
        recommendationId,
        status,
      );

      // Update in received recommendations
      final updatedReceived = state.receivedRecommendations.map((r) {
        return r.id == recommendationId ? updatedRecommendation : r;
      }).toList();

      state = state.copyWith(receivedRecommendations: updatedReceived);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
