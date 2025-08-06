// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      companyId: (json['company_id'] as num?)?.toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      format: json['format'] as String,
      location: json['location'] as Map<String, dynamic>?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      maxAttendees: (json['max_attendees'] as num?)?.toInt(),
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isPublished: json['is_published'] as bool,
      requiresApproval: json['requires_approval'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      company: json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
      userIsAttending: json['user_is_attending'] as bool?,
      attendeesCount: (json['attendees_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'company_id': instance.companyId,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'format': instance.format,
      'location': instance.location,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'max_attendees': instance.maxAttendees,
      'price': instance.price,
      'image': instance.image,
      'tags': instance.tags,
      'is_published': instance.isPublished,
      'requires_approval': instance.requiresApproval,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'company': instance.company,
      'user_is_attending': instance.userIsAttending,
      'attendees_count': instance.attendeesCount,
    };
