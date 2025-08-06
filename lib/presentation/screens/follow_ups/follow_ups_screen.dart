import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/follow_up_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_bottom_navigation.dart';
import '../../../data/models/follow_up_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class FollowUpsScreen extends ConsumerStatefulWidget {
  const FollowUpsScreen({super.key});

  @override
  ConsumerState<FollowUpsScreen> createState() => _FollowUpsScreenState();
}

class _FollowUpsScreenState extends ConsumerState<FollowUpsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(followUpProvider.notifier).loadFollowUps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final followUpState = ref.watch(followUpProvider);

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
                    'Seguimientos',
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
                    onPressed: () => _showCreateFollowUpDialog(context),
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
        body: followUpState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(AppConstants.primaryColorValue),
                ),
              )
            : followUpState.error != null
                ? _buildErrorWidget(followUpState.error!)
                : followUpState.followUps.isEmpty
                    ? _buildEmptyWidget()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(followUpProvider.notifier)
                              .loadFollowUps();
                        },
                        color: const Color(AppConstants.primaryColorValue),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                          itemCount: followUpState.followUps.length,
                          itemBuilder: (context, index) {
                            final followUp = followUpState.followUps[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildFollowUpCard(followUp),
                            );
                          },
                        ),
                      ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildFollowUpCard(FollowUpModel followUp) {
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
                    Icons.assignment,
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
                        'Reunión con ${followUp.participantName}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(AppConstants.textPrimaryValue),
                            ),
                      ),
                      const SizedBox(height: 4),
                      if (followUp.participantCompany != null)
                        Text(
                          followUp.participantCompany!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(
                                        AppConstants.textSecondaryValue),
                                  ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(followUp.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(followUp.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Información del seguimiento
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(AppConstants.surfaceColorValue),
                borderRadius: BorderRadius.circular(12),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Color(AppConstants.primaryColorValue),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(followUp.followUpDate),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(AppConstants.textPrimaryValue),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  if (followUp.followUpNotes != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(AppConstants.primaryColorValue)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.note,
                            size: 16,
                            color: Color(AppConstants.primaryColorValue),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notas de seguimiento',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: const Color(
                                          AppConstants.textSecondaryValue),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                followUp.followUpNotes!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: const Color(
                                          AppConstants.textPrimaryValue),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (followUp.actionItems != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(AppConstants.primaryColorValue)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.checklist,
                            size: 16,
                            color: Color(AppConstants.primaryColorValue),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Acciones a seguir',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: const Color(
                                          AppConstants.textSecondaryValue),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                followUp.actionItems!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: const Color(
                                          AppConstants.textPrimaryValue),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botones de acción
            Row(
              children: [
                if (followUp.status == 'pending') ...[
                  Expanded(
                    child: TextButton(
                      onPressed: () => _showCompleteFollowUpDialog(followUp),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                      child: Text(
                        'Completar',
                        style: TextStyle(
                          color: const Color(AppConstants.successColorValue),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: CustomButton(
                    text: 'Ver Detalles',
                    onPressed: () => _showFollowUpDetails(followUp),
                    backgroundColor:
                        const Color(AppConstants.primaryColorValue),
                    height: 44,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'completed':
        return 'Completado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
                Icons.assignment_outlined,
                size: 40,
                color: Color(AppConstants.primaryColorValue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No hay seguimientos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(AppConstants.textPrimaryValue),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea tu primer seguimiento de reunión',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(AppConstants.textSecondaryValue),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Crear Seguimiento',
              onPressed: () => _showCreateFollowUpDialog(context),
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
              'Error al cargar seguimientos',
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
              onPressed: () =>
                  ref.read(followUpProvider.notifier).loadFollowUps(),
              backgroundColor: const Color(AppConstants.primaryColorValue),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateFollowUpDialog(BuildContext context) {
    final meetingIdController = TextEditingController();
    final notesController = TextEditingController();
    final actionItemsController = TextEditingController();
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
                      Icons.assignment_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Crear Seguimiento',
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
                      controller: meetingIdController,
                      label: 'ID de la reunión',
                      prefixIcon: Icons.meeting_room,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: notesController,
                      label: 'Notas de seguimiento',
                      prefixIcon: Icons.note,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: actionItemsController,
                      label: 'Acciones a seguir',
                      prefixIcon: Icons.checklist,
                      maxLines: 2,
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
                      text: 'Crear Seguimiento',
                      onPressed: () {
                        if (meetingIdController.text.isNotEmpty) {
                          ref.read(followUpProvider.notifier).createFollowUp(
                                meetingId: int.parse(meetingIdController.text),
                                followUpDate: selectedDate,
                                followUpNotes: notesController.text.isEmpty
                                    ? null
                                    : notesController.text,
                                actionItems: actionItemsController.text.isEmpty
                                    ? null
                                    : actionItemsController.text,
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

  void _showCompleteFollowUpDialog(FollowUpModel followUp) {
    final notesController =
        TextEditingController(text: followUp.followUpNotes ?? '');

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
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(AppConstants.successColorValue)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(AppConstants.successColorValue),
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Completar Seguimiento',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(AppConstants.textPrimaryValue),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Seguimiento de reunión con ${followUp.participantName}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(AppConstants.textSecondaryValue),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: notesController,
                label: 'Notas finales',
                prefixIcon: Icons.note,
                maxLines: 3,
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
                    child: CustomButton(
                      text: 'Completar',
                      onPressed: () {
                        ref
                            .read(followUpProvider.notifier)
                            .updateFollowUpStatus(
                              followUp.id,
                              'completed',
                              notesController.text,
                            );
                        Navigator.pop(context);
                      },
                      backgroundColor:
                          const Color(AppConstants.successColorValue),
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

  void _showFollowUpDetails(FollowUpModel followUp) {
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
                      Icons.assignment,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Seguimiento - ${followUp.participantName}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(AppConstants.textPrimaryValue),
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(AppConstants.surfaceColorValue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.calendar_today, 'Fecha',
                        _formatDate(followUp.followUpDate)),
                    if (followUp.followUpNotes != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                          Icons.note, 'Notas', followUp.followUpNotes!),
                    ],
                    if (followUp.actionItems != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                          Icons.checklist, 'Acciones', followUp.actionItems!),
                    ],
                    const SizedBox(height: 12),
                    _buildDetailRow(
                        Icons.info, 'Estado', _getStatusText(followUp.status)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Cerrar',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: const Color(AppConstants.primaryColorValue),
                  height: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(AppConstants.primaryColorValue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(AppConstants.primaryColorValue),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(AppConstants.textSecondaryValue),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(AppConstants.textPrimaryValue),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
