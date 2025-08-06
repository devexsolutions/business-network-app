import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/custom_bottom_navigation.dart';

class BusinessScreen extends ConsumerWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.backgroundColorValue),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: FlexibleSpaceBar(
                  title: Text(
                    'Centro de Negocios',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.business_center,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gestiona tus oportunidades',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(
                                          AppConstants.textPrimaryValue),
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Herramientas para hacer crecer tu red profesional',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: const Color(
                                          AppConstants.textSecondaryValue),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Business Tools Grid
              Text(
                'Herramientas de Negocio',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(AppConstants.textPrimaryValue),
                    ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildBusinessCard(
                    context,
                    'Recomendaciones',
                    'Recomienda contactos y recibe recomendaciones',
                    Icons.recommend,
                    const Color(0xFF4A90E2),
                    () => context.go('/recommendations'),
                  ),
                  _buildBusinessCard(
                    context,
                    'Reuniones 1 a 1',
                    'Programa y gestiona reuniones individuales',
                    Icons.people,
                    const Color(0xFF7B68EE),
                    () => context.go('/meetings'),
                  ),
                  _buildBusinessCard(
                    context,
                    'Seguimientos',
                    'Haz seguimiento a tus reuniones y contactos',
                    Icons.assignment,
                    const Color(0xFF50C878),
                    () => context.go('/follow-ups'),
                  ),
                  _buildBusinessCard(
                    context,
                    'Eventos',
                    'Participa en eventos de networking',
                    Icons.event,
                    const Color(0xFFFF6B6B),
                    () => context.go('/events'),
                  ),
                  _buildBusinessCard(
                    context,
                    'Mi Red',
                    'Explora y conecta con otros profesionales',
                    Icons.network_check,
                    const Color(0xFFFFB347),
                    () => context.go('/network'),
                  ),
                  _buildBusinessCard(
                    context,
                    'Mi Perfil',
                    'Actualiza tu información profesional',
                    Icons.person,
                    const Color(0xFF9370DB),
                    () => context.go('/profile'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildBusinessCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(AppConstants.textPrimaryValue),
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(AppConstants.textSecondaryValue),
                        height: 1.3,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
