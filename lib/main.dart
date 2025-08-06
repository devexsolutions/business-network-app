import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'core/constants/app_constants.dart';
import 'core/services/api_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/meeting_provider.dart';

void main() {
  // Inicializar servicios
  ApiService().initialize();

  runApp(
    provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => UserProvider()),
        provider.ChangeNotifierProvider(create: (_) => MeetingProvider()),
      ],
      child: const ProviderScope(
        child: BusinessNetworkApp(),
      ),
    ),
  );
}

class BusinessNetworkApp extends ConsumerWidget {
  const BusinessNetworkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Configuración del router
      routerConfig: router,

      // Tema de la aplicación
      theme: AppTheme.lightTheme,

      // Tema oscuro (opcional)
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppConstants.primaryColorValue),
          brightness: Brightness.dark,
        ),
      ),

      // Configuración de localización
      locale: const Locale('es', 'ES'),

      // Configuración de accesibilidad
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
