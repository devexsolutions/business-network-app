// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) => Connection(
      id: (json['id'] as num).toInt(),
      requesterId: (json['requester_id'] as num).toInt(),
      addresseeId: (json['addressee_id'] as num).toInt(),
      status: json['status'] as String,
      message: json['message'] as String?,
      acceptedAt: json['accepted_at'] == null
          ? null
          : DateTime.parse(json['accepted_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      requester: json['requester'] == null
          ? null
          : User.fromJson(json['requester'] as Map<String, dynamic>),
      addressee: json['addressee'] == null
          ? null
          : User.fromJson(json['addressee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requester_id': instance.requesterId,
      'addressee_id': instance.addresseeId,
      'status': instance.status,
      'message': instance.message,
      'accepted_at': instance.acceptedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'requester': instance.requester,
      'addressee': instance.addressee,
    };

CreateConnectionRequest _$CreateConnectionRequestFromJson(
        Map<String, dynamic> json) =>
    CreateConnectionRequest(
      userId: (json['user_id'] as num).toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$CreateConnectionRequestToJson(
        CreateConnectionRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'message': instance.message,
    };
