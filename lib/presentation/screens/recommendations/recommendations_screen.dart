import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/recommendation_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_bottom_navigation.dart';
import '../../../data/models/recommendation_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() =>
      _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recommendationProvider.notifier).loadRecommendations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommendationState = ref.watch(recommendationProvider);

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
                    'Recomendaciones',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                    indicatorColor: const Color(AppConstants.primaryColorValue),
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
                      Tab(text: 'Enviadas'),
                      Tab(text: 'Recibidas'),
                      Tab(text: 'Crear'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: recommendationState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(AppConstants.primaryColorValue),
                ),
              )
            : recommendationState.error != null
                ? _buildErrorWidget(recommendationState.error!)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRecommendationsList(
                          recommendationState.sentRecommendations),
                      _buildRecommendationsList(
                          recommendationState.receivedRecommendations),
                      _buildCreateRecommendationForm(),
                    ],
                  ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildRecommendationsList(List<RecommendationModel> recommendations) {
    if (recommendations.isEmpty) {
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(recommendationProvider.notifier).loadRecommendations();
      },
      color: const Color(AppConstants.primaryColorValue),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          final recommendation = recommendations[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildRecommendationCard(recommendation),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationCard(RecommendationModel recommendation) {
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
                    Icons.recommend,
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
                        'De: ${recommendation.recommenderName}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(AppConstants.textPrimaryValue),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Para: ${recommendation.recommendeeName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  const Color(AppConstants.textSecondaryValue),
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
                    color: _getStatusColor(recommendation.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(recommendation.status),
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

            // Información de la recomendación
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(AppConstants.surfaceColorValue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (recommendation.description != null) ...[
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
                            Icons.description,
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
                                'Descripción',
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
                                recommendation.description!,
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
                    const SizedBox(height: 12),
                  ],
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
                        _formatDate(recommendation.createdAt),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(AppConstants.textPrimaryValue),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (recommendation.status == 'pending') ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _updateRecommendationStatus(
                        recommendation.id,
                        'rejected',
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                      child: Text(
                        'Rechazar',
                        style: TextStyle(
                          color: Color(AppConstants.errorColorValue),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Aceptar',
                      onPressed: () => _updateRecommendationStatus(
                        recommendation.id,
                        'accepted',
                      ),
                      backgroundColor:
                          const Color(AppConstants.successColorValue),
                      height: 44,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreateRecommendationForm() {
    final recommenderController = TextEditingController();
    final recommendeeController = TextEditingController();
    final descriptionController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
                    Icons.recommend,
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
                        'Crear Nueva Recomendación',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(AppConstants.textPrimaryValue),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Conecta a dos personas de tu red',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  const Color(AppConstants.textSecondaryValue),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: recommenderController,
              label: 'A quién recomiendas (ID)',
              prefixIcon: Icons.person,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: recommendeeController,
              label: 'A quién se lo recomiendas (ID)',
              prefixIcon: Icons.person_add,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: descriptionController,
              label: 'Descripción de la recomendación',
              prefixIcon: Icons.description,
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Crear Recomendación',
                onPressed: () {
                  if (recommenderController.text.isNotEmpty &&
                      recommendeeController.text.isNotEmpty) {
                    ref
                        .read(recommendationProvider.notifier)
                        .createRecommendation(
                          recommenderId: int.parse(recommenderController.text),
                          recommendeeId: int.parse(recommendeeController.text),
                          description: descriptionController.text.isEmpty
                              ? null
                              : descriptionController.text,
                        );

                    // Clear form
                    recommenderController.clear();
                    recommendeeController.clear();
                    descriptionController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            const Text('Recomendación creada exitosamente'),
                        backgroundColor:
                            const Color(AppConstants.successColorValue),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.borderRadius),
                        ),
                      ),
                    );
                  }
                },
                backgroundColor: const Color(AppConstants.primaryColorValue),
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
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
                Icons.recommend_outlined,
                size: 40,
                color: Color(AppConstants.primaryColorValue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No hay recomendaciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(AppConstants.textPrimaryValue),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea tu primera recomendación para conectar contactos',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(AppConstants.textSecondaryValue),
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
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: Color(AppConstants.errorColorValue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Error al cargar recomendaciones',
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
              onPressed: () => ref
                  .read(recommendationProvider.notifier)
                  .loadRecommendations(),
              backgroundColor: const Color(AppConstants.primaryColorValue),
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
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'accepted':
        return 'Aceptada';
      case 'rejected':
        return 'Rechazada';
      default:
        return 'Desconocido';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _updateRecommendationStatus(int recommendationId, String status) {
    ref.read(recommendationProvider.notifier).updateRecommendationStatus(
          recommendationId,
          status,
        );
  }
}
