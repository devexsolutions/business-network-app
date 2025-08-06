import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../../core/constants/app_constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/home');
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo y título
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(AppConstants.primaryColorValue),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: const Icon(
                        Icons.business_center,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(AppConstants.primaryColorValue),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Conecta, crece y prospera',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Formulario
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Por favor ingresa un email válido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    if (value.length < AppConstants.minPasswordLength) {
                      return 'La contraseña debe tener al menos ${AppConstants.minPasswordLength} caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Botón de login
                CustomButton(
                  text: 'Iniciar Sesión',
                  onPressed: authState.isLoading ? null : _handleLogin,
                  isLoading: authState.isLoading,
                ),

                const SizedBox(height: 16),

                // Link a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text('Regístrate'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Datos de prueba
                if (true) // Solo en desarrollo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Datos de prueba:',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Email: juan@example.com'),
                        const Text('Contraseña: password'),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            _emailController.text = 'juan@example.com';
                            _passwordController.text = 'password';
                          },
                          child: const Text('Usar datos de prueba'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }
}
