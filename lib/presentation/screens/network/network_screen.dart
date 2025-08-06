import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/network/user_card.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUsers();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
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
                        'Mi Red',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      centerTitle: false,
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor:
                            const Color(AppConstants.primaryColorValue),
                        labelColor: const Color(AppConstants.primaryColorValue),
                        unselectedLabelColor:
                            const Color(AppConstants.textSecondaryValue),
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        tabs: const [
                          Tab(text: 'Todos'),
                          Tab(text: 'Sugerencias'),
                          Tab(text: 'Búsqueda'),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                // Barra de búsqueda
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomTextField(
                    controller: _searchController,
                    label: 'Buscar usuarios...',
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });

                      if (value.isNotEmpty && _tabController.index == 2) {
                        _performSearch(value);
                      }
                    },
                  ),
                ),

                // Contenido de las pestañas
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Pestaña: Todos los usuarios
                      _buildAllUsersTab(userProvider),

                      // Pestaña: Sugerencias
                      _buildSuggestionsTab(userProvider),

                      // Pestaña: Búsqueda
                      _buildSearchTab(userProvider),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigation(context),
        );
      },
    );
  }

  Widget _buildAllUsersTab(UserProvider userProvider) {
    if (userProvider.isLoading && userProvider.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.error != null && userProvider.users.isEmpty) {
      return _buildErrorWidget(userProvider.error!);
    }

    if (userProvider.users.isEmpty) {
      return _buildEmptyWidget('No hay usuarios disponibles');
    }

    return RefreshIndicator(
      onRefresh: () async {
        await userProvider.loadUsers();
      },
      color: const Color(AppConstants.primaryColorValue),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: UserCard(user: user),
          );
        },
      ),
    );
  }

  Widget _buildSuggestionsTab(UserProvider userProvider) {
    // For now, show the same users as suggestions
    // You can implement a separate suggestions logic later
    if (userProvider.users.isEmpty) {
      return _buildEmptyWidget('No hay sugerencias disponibles');
    }

    return RefreshIndicator(
      onRefresh: () async {
        await userProvider.loadUsers();
      },
      color: const Color(AppConstants.primaryColorValue),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        itemCount: userProvider.users.length,
        itemBuilder: (context, index) {
          final user = userProvider.users[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: UserCard(user: user),
          );
        },
      ),
    );
  }

  Widget _buildSearchTab(UserProvider userProvider) {
    if (_searchQuery.isEmpty) {
      return _buildEmptyWidget(
        'Ingresa palabras clave para buscar usuarios',
        icon: Icons.search,
      );
    }

    if (userProvider.isLoading && userProvider.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userProvider.error != null && userProvider.users.isEmpty) {
      return _buildErrorWidget(userProvider.error!);
    }

    if (userProvider.users.isEmpty) {
      return _buildEmptyWidget(
          'No se encontraron usuarios con "$_searchQuery"');
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: userProvider.users.length,
      itemBuilder: (context, index) {
        final user = userProvider.users[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: UserCard(user: user),
        );
      },
    );
  }

  Widget _buildEmptyWidget(String message, {IconData? icon}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(AppConstants.primaryColorValue)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon ?? Icons.people_outline,
                size: 40,
                color: const Color(AppConstants.primaryColorValue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(AppConstants.textSecondaryValue),
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(AppConstants.errorColorValue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 40,
                color: Color(AppConstants.errorColorValue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Error al cargar usuarios',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Color(AppConstants.errorColorValue),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(AppConstants.textSecondaryValue),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).loadUsers();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(AppConstants.primaryColorValue),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
              child: const Text(
                'Reintentar',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    Provider.of<UserProvider>(context, listen: false).loadUsers(search: query);
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(AppConstants.primaryColorValue),
        unselectedItemColor: const Color(AppConstants.textLightValue),
        currentIndex: 1, // Network is selected
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              // Already on network
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
      ),
    );
  }
}
