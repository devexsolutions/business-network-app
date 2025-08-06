import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/event_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../../data/models/event_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventProvider.notifier).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);

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
                    'Eventos',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16, top: 8),
                  child: FloatingActionButton.small(
                    onPressed: () => _showCreateEventDialog(context),
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    child: const Icon(Icons.add, size: 20),
                  ),
                ),
              ],
            ),
          ];
        },
        body: eventState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(AppConstants.primaryColorValue),
                ),
              )
            : eventState.error != null
                ? _buildErrorWidget(eventState.error!)
                : eventState.events.isEmpty
                    ? _buildEmptyWidget()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref.read(eventProvider.notifier).loadEvents();
                        },
                        color: const Color(AppConstants.primaryColorValue),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                          itemCount: eventState.events.length,
                          itemBuilder: (context, index) {
                            final event = eventState.events[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildEventCard(event),
                            );
                          },
                        ),
                      ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildEventCard(EventModel event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(AppConstants.primaryColorValue),
                        const Color(AppConstants.primaryColorValue)
                            .withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(AppConstants.primaryColorValue)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(AppConstants.textPrimaryValue),
                            ),
                      ),
                      const SizedBox(height: 4),
                      if (event.description != null &&
                          event.description!.isNotEmpty)
                        Text(
                          event.description!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(
                                        AppConstants.textSecondaryValue),
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Información del evento
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(AppConstants.surfaceColorValue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(AppConstants.primaryColorValue)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Color(AppConstants.primaryColorValue),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatDate(event.eventDate),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    const Color(AppConstants.textPrimaryValue),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(AppConstants.primaryColorValue)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(AppConstants.primaryColorValue),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.locationString ?? 'Sin ubicación',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    const Color(AppConstants.textPrimaryValue),
                                fontWeight: FontWeight.w500,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (event.maxAttendees != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(AppConstants.primaryColorValue)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.people,
                            size: 16,
                            color: Color(AppConstants.primaryColorValue),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Capacidad: ${event.maxAttendees}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: const Color(
                                      AppConstants.textPrimaryValue),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botón de registro
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: event.isRegistered ? 'Ya Registrado' : 'Registrarse',
                onPressed: event.isRegistered
                    ? null
                    : () => _registerForEvent(event.id),
                backgroundColor: event.isRegistered
                    ? const Color(AppConstants.successColorValue)
                    : const Color(AppConstants.primaryColorValue),
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _registerForEvent(int eventId) {
    ref.read(eventProvider.notifier).registerForEvent(eventId);
  }

  Widget _buildEmptyWidget() {
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
              child: const Icon(
                Icons.event_outlined,
                size: 40,
                color: Color(AppConstants.primaryColorValue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No hay eventos disponibles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(AppConstants.textPrimaryValue),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea el primer evento para tu red',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(AppConstants.textSecondaryValue),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Crear Evento',
              onPressed: () => _showCreateEventDialog(context),
              backgroundColor: const Color(AppConstants.primaryColorValue),
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
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Color(AppConstants.errorColorValue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Error al cargar eventos',
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
            CustomButton(
              text: 'Reintentar',
              onPressed: () => ref.read(eventProvider.notifier).loadEvents(),
              backgroundColor: const Color(AppConstants.primaryColorValue),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final maxAttendeesController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      Icons.event_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Crear Evento',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(AppConstants.textPrimaryValue),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: titleController,
                      label: 'Título del evento',
                      prefixIcon: Icons.title,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: descriptionController,
                      label: 'Descripción',
                      prefixIcon: Icons.description,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: locationController,
                      label: 'Ubicación',
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: maxAttendeesController,
                      label: 'Capacidad máxima (opcional)',
                      prefixIcon: Icons.people,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: const Color(AppConstants.textSecondaryValue),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: 'Crear Evento',
                      onPressed: () {
                        if (titleController.text.isNotEmpty) {
                          ref.read(eventProvider.notifier).createEvent(
                                title: titleController.text,
                                description: descriptionController.text,
                                location: locationController.text,
                                eventDate: selectedDate,
                                maxAttendees:
                                    int.tryParse(maxAttendeesController.text),
                              );
                          Navigator.pop(context);
                        }
                      },
                      backgroundColor:
                          const Color(AppConstants.primaryColorValue),
                      height: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        currentIndex: 2, // Events is selected
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
              context.go('/network');
              break;
            case 2:
              // Already on events
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
