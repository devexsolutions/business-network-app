// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessRecommendation _$BusinessRecommendationFromJson(
        Map<String, dynamic> json) =>
    BusinessRecommendation(
      id: (json['id'] as num).toInt(),
      recommenderId: (json['recommender_id'] as num).toInt(),
      recommendedToId: (json['recommended_to_id'] as num).toInt(),
      recommendedUserId: (json['recommended_user_id'] as num).toInt(),
      recommendationDate: DateTime.parse(json['recommendation_date'] as String),
      businessDescription: json['business_description'] as String,
      whyRecommended: json['why_recommended'] as String,
      contactInfo: json['contact_info'] as Map<String, dynamic>?,
      recommendationType: json['recommendation_type'] as String,
      priorityLevel: json['priority_level'] as String,
      status: json['status'] as String,
      followUpNotes: json['follow_up_notes'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      contactedAt: json['contacted_at'] == null
          ? null
          : DateTime.parse(json['contacted_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      isMutual: json['is_mutual'] as bool,
      estimatedValue: (json['estimated_value'] as num?)?.toDouble(),
      outcomeNotes: json['outcome_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      recommender: json['recommender'] == null
          ? null
          : User.fromJson(json['recommender'] as Map<String, dynamic>),
      recommendedTo: json['recommended_to'] == null
          ? null
          : User.fromJson(json['recommended_to'] as Map<String, dynamic>),
      recommendedUser: json['recommended_user'] == null
          ? null
          : User.fromJson(json['recommended_user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusinessRecommendationToJson(
        BusinessRecommendation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recommender_id': instance.recommenderId,
      'recommended_to_id': instance.recommendedToId,
      'recommended_user_id': instance.recommendedUserId,
      'recommendation_date': instance.recommendationDate.toIso8601String(),
      'business_description': instance.businessDescription,
      'why_recommended': instance.whyRecommended,
      'contact_info': instance.contactInfo,
      'recommendation_type': instance.recommendationType,
      'priority_level': instance.priorityLevel,
      'status': instance.status,
      'follow_up_notes': instance.followUpNotes,
      'tags': instance.tags,
      'contacted_at': instance.contactedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'is_mutual': instance.isMutual,
      'estimated_value': instance.estimatedValue,
      'outcome_notes': instance.outcomeNotes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'recommender': instance.recommender,
      'recommended_to': instance.recommendedTo,
      'recommended_user': instance.recommendedUser,
    };
