import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'user_model.dart';

part 'recommendation_model.g.dart';

// Alias para mantener consistencia con el resto de la aplicación
typedef RecommendationModel = BusinessRecommendation;

@JsonSerializable()
class BusinessRecommendation extends Equatable {
  final int id;
  @JsonKey(name: 'recommender_id')
  final int recommenderId;
  @JsonKey(name: 'recommended_to_id')
  final int recommendedToId;
  @JsonKey(name: 'recommended_user_id')
  final int recommendedUserId;
  @JsonKey(name: 'recommendation_date')
  final DateTime recommendationDate;
  @JsonKey(name: 'business_description')
  final String businessDescription;
  @JsonKey(name: 'why_recommended')
  final String whyRecommended;
  @JsonKey(name: 'contact_info')
  final Map<String, dynamic>? contactInfo;
  @JsonKey(name: 'recommendation_type')
  final String recommendationType;
  @JsonKey(name: 'priority_level')
  final String priorityLevel;
  final String status;
  @JsonKey(name: 'follow_up_notes')
  final String? followUpNotes;
  final List<String>? tags;
  @JsonKey(name: 'contacted_at')
  final DateTime? contactedAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @JsonKey(name: 'is_mutual')
  final bool isMutual;
  @JsonKey(name: 'estimated_value')
  final double? estimatedValue;
  @JsonKey(name: 'outcome_notes')
  final String? outcomeNotes;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User? recommender;
  @JsonKey(name: 'recommended_to')
  final User? recommendedTo;
  @JsonKey(name: 'recommended_user')
  final User? recommendedUser;

  const BusinessRecommendation({
    required this.id,
    required this.recommenderId,
    required this.recommendedToId,
    required this.recommendedUserId,
    required this.recommendationDate,
    required this.businessDescription,
    required this.whyRecommended,
    this.contactInfo,
    required this.recommendationType,
    required this.priorityLevel,
    required this.status,
    this.followUpNotes,
    this.tags,
    this.contactedAt,
    this.completedAt,
    required this.isMutual,
    this.estimatedValue,
    this.outcomeNotes,
    required this.createdAt,
    required this.updatedAt,
    this.recommender,
    this.recommendedTo,
    this.recommendedUser,
  });

  factory BusinessRecommendation.fromJson(Map<String, dynamic> json) =>
      _$BusinessRecommendationFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessRecommendationToJson(this);

  @override
  List<Object?> get props => [
        id,
        recommenderId,
        recommendedToId,
        recommendedUserId,
        recommendationDate,
        businessDescription,
        whyRecommended,
        contactInfo,
        recommendationType,
        priorityLevel,
        status,
        followUpNotes,
        tags,
        contactedAt,
        completedAt,
        isMutual,
        estimatedValue,
        outcomeNotes,
        createdAt,
        updatedAt,
        recommender,
        recommendedTo,
        recommendedUser,
      ];

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'contacted':
        return 'Contactado';
      case 'meeting_scheduled':
        return 'Reunión Programada';
      case 'business_done':
        return 'Negocio Realizado';
      case 'not_interested':
        return 'No Interesado';
      case 'no_response':
        return 'Sin Respuesta';
      default:
        return 'Desconocido';
    }
  }

  String get typeText {
    switch (recommendationType) {
      case 'business_opportunity':
        return 'Oportunidad de Negocio';
      case 'service_provider':
        return 'Proveedor de Servicios';
      case 'potential_client':
        return 'Cliente Potencial';
      case 'partnership':
        return 'Sociedad';
      case 'other':
        return 'Otro';
      default:
        return 'No definido';
    }
  }

  String get priorityText {
    switch (priorityLevel) {
      case 'low':
        return 'Baja';
      case 'medium':
        return 'Media';
      case 'high':
        return 'Alta';
      case 'urgent':
        return 'Urgente';
      default:
        return 'No definida';
    }
  }

  int get priorityColor {
    switch (priorityLevel) {
      case 'low':
        return 0xFF4CAF50; // Verde
      case 'medium':
        return 0xFFFF9800; // Naranja
      case 'high':
        return 0xFFFF5722; // Naranja oscuro
      case 'urgent':
        return 0xFFD32F2F; // Rojo
      default:
        return 0xFF9E9E9E; // Gris
    }
  }

  String get estimatedValueText {
    if (estimatedValue == null || estimatedValue == 0) {
      return 'No especificado';
    }
    return '€${estimatedValue!.toStringAsFixed(2)}';
  }

  // Métodos adicionales para compatibilidad con la UI
  String get recommenderName => recommender?.name ?? 'Usuario desconocido';
  String get recommendeeName => recommendedTo?.name ?? 'Usuario desconocido';
  String? get description =>
      businessDescription.isNotEmpty ? businessDescription : null;

  BusinessRecommendation copyWith({
    int? id,
    int? recommenderId,
    int? recommendedToId,
    int? recommendedUserId,
    DateTime? recommendationDate,
    String? businessDescription,
    String? whyRecommended,
    Map<String, dynamic>? contactInfo,
    String? recommendationType,
    String? priorityLevel,
    String? status,
    String? followUpNotes,
    List<String>? tags,
    DateTime? contactedAt,
    DateTime? completedAt,
    bool? isMutual,
    double? estimatedValue,
    String? outcomeNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? recommender,
    User? recommendedTo,
    User? recommendedUser,
  }) {
    return BusinessRecommendation(
      id: id ?? this.id,
      recommenderId: recommenderId ?? this.recommenderId,
      recommendedToId: recommendedToId ?? this.recommendedToId,
      recommendedUserId: recommendedUserId ?? this.recommendedUserId,
      recommendationDate: recommendationDate ?? this.recommendationDate,
      businessDescription: businessDescription ?? this.businessDescription,
      whyRecommended: whyRecommended ?? this.whyRecommended,
      contactInfo: contactInfo ?? this.contactInfo,
      recommendationType: recommendationType ?? this.recommendationType,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      status: status ?? this.status,
      followUpNotes: followUpNotes ?? this.followUpNotes,
      tags: tags ?? this.tags,
      contactedAt: contactedAt ?? this.contactedAt,
      completedAt: completedAt ?? this.completedAt,
      isMutual: isMutual ?? this.isMutual,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      outcomeNotes: outcomeNotes ?? this.outcomeNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      recommender: recommender ?? this.recommender,
      recommendedTo: recommendedTo ?? this.recommendedTo,
      recommendedUser: recommendedUser ?? this.recommendedUser,
    );
  }
}
