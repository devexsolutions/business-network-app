import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileStatsAsync = ref.watch(profileStatsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Hola, ${user?.name ?? 'Usuario'}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(AppConstants.primaryColorValue),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Implementar notificaciones
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  context.go('/profile');
                  break;
                case 'settings':
                  // TODO: Implementar configuración
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Configuración próximamente')),
                  );
                  break;
                case 'logout':
                  _showLogoutDialog(context, ref);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 8),
                    Text('Mi Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileStatsProvider);
          await ref.read(authProvider.notifier).refreshUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de bienvenida
              _buildWelcomeCard(context, user),

              const SizedBox(height: 20),

              // Estadísticas del perfil
              profileStatsAsync.when(
                data: (stats) => _buildStatsCard(context, stats),
                loading: () => _buildStatsLoadingCard(),
                error: (error, stack) =>
                    _buildErrorCard(context, error.toString()),
              ),

              const SizedBox(height: 20),

              // Acciones rápidas
              _buildQuickActions(context),

              const SizedBox(height: 20),

              // Actividad reciente
              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, ${user?.name ?? 'Usuario'}!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.company?.name ?? 'Empresa no asignada',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
                if (user?.position != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    user!.position!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(AppConstants.surfaceColorValue),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(AppConstants.primaryColorValue)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Color(AppConstants.primaryColorValue),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tu Actividad',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildStatItem(
                context,
                'Perfil',
                '${stats.profileCompletion}%',
                Icons.person_outline,
                const Color(AppConstants.primaryColorValue),
              ),
              _buildStatItem(
                context,
                'Conexiones',
                '${stats.connectionsCount}',
                Icons.people_outline,
                const Color(AppConstants.secondaryColorValue),
              ),
              _buildStatItem(
                context,
                'Posts',
                '${stats.postsCount}',
                Icons.article_outlined,
                const Color(AppConstants.accentColorValue),
              ),
              _buildStatItem(
                context,
                'Eventos',
                '${stats.eventsAttended}',
                Icons.event_outlined,
                const Color(AppConstants.accentColorValue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsLoadingCard() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600], size: 32),
          const SizedBox(height: 8),
          Text(
            'Error al cargar estadísticas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.red[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              context,
              'Crear Post',
              Icons.add_circle_outline,
              const Color(AppConstants.primaryColorValue),
              () {
                _showCreatePostDialog(context);
              },
            ),
            _buildActionCard(
              context,
              'Buscar Usuarios',
              Icons.search,
              const Color(AppConstants.secondaryColorValue),
              () {
                context.go('/network');
              },
            ),
            _buildActionCard(
              context,
              'Mis Reuniones',
              Icons.calendar_today,
              const Color(AppConstants.accentColorValue),
              () {
                context.go('/meetings');
              },
            ),
            _buildActionCard(
              context,
              'Recomendaciones',
              Icons.recommend,
              Colors.green,
              () {
                context.go('/recommendations');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad Reciente',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'No hay actividad reciente',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(AppConstants.primaryColorValue),
      unselectedItemColor: Colors.grey,
      currentIndex: 0, // Home is selected
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            context.go('/network');
            break;
          case 2:
            context.go('/events');
            break;
          case 3:
            context.go('/business');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Red',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          activeIcon: Icon(Icons.event),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_center_outlined),
          activeIcon: Icon(Icons.business_center),
          label: 'Negocios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Contenido del post',
                border: OutlineInputBorder(),
                hintText: '¿Qué quieres compartir?',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                // TODO: Implementar creación de post
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post creado exitosamente')),
                );
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).logout();
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
