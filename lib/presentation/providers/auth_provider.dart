import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/auth_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }

  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        state = state.copyWith(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isAuthenticated: false,
        isLoading: false,
      );
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authRepository.login(request);

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Register
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? position,
    int? companyId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        position: position,
        companyId: companyId,
      );

      final response = await _authRepository.register(request);

      state = state.copyWith(
        user: response.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Logout
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authRepository.logout();
      state = const AuthState(isAuthenticated: false);
    } catch (e) {
      // Logout local aunque falle el servidor
      state = const AuthState(isAuthenticated: false);
    }
  }

  // Refresh user data
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;

    try {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

// Profile stats provider
final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  try {
    return await authRepository.getProfileStats();
  } catch (e) {
    // Return default stats if there's an error
    return const ProfileStats(
      profileCompletion: 0,
      connectionsCount: 0,
      postsCount: 0,
      eventsCreated: 0,
      eventsAttended: 0,
      membershipStatus: 'inactive',
      isActiveMember: false,
      membershipExpiring: false,
    );
  }
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});
