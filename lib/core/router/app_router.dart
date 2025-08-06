import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/network/network_screen.dart';
import '../../presentation/screens/events/events_screen.dart';
import '../../presentation/screens/meetings/meetings_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/recommendations/recommendations_screen.dart';
import '../../presentation/screens/follow_ups/follow_ups_screen.dart';
import '../../presentation/screens/business/business_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;

      // Si está cargando, no redirigir
      if (isLoading) return null;

      final isLoginRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Si no está autenticado y no está en una ruta de auth, ir a login
      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      // Si está autenticado y está en una ruta de auth, ir a home
      if (isAuthenticated && isLoginRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Ruta raíz - redirige según el estado de auth
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final isAuthenticated = ref.read(authProvider).isAuthenticated;
          return isAuthenticated ? '/home' : '/login';
        },
      ),

      // Rutas de autenticación
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Rutas principales (requieren autenticación)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: '/network',
        name: 'network',
        builder: (context, state) => const NetworkScreen(),
      ),

      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) => const EventsScreen(),
      ),

      GoRoute(
        path: '/business',
        name: 'business',
        builder: (context, state) => const BusinessScreen(),
      ),

      GoRoute(
        path: '/meetings',
        name: 'meetings',
        builder: (context, state) => const MeetingsScreen(),
      ),

      GoRoute(
        path: '/recommendations',
        name: 'recommendations',
        builder: (context, state) => const RecommendationsScreen(),
      ),

      GoRoute(
        path: '/follow-ups',
        name: 'follow-ups',
        builder: (context, state) => const FollowUpsScreen(),
      ),
    ],

    // Manejo de errores
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La página que buscas no existe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Ir al Inicio'),
            ),
          ],
        ),
      ),
    ),
  );
});
