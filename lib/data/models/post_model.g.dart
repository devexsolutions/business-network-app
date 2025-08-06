// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      title: json['title'] as String?,
      content: json['content'] as String,
      type: json['type'] as String,
      media:
          (json['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      likesCount: (json['likes_count'] as num).toInt(),
      commentsCount: (json['comments_count'] as num).toInt(),
      sharesCount: (json['shares_count'] as num).toInt(),
      isPublished: json['is_published'] as bool,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      userHasLiked: json['user_has_liked'] as bool?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'type': instance.type,
      'media': instance.media,
      'metadata': instance.metadata,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'shares_count': instance.sharesCount,
      'is_published': instance.isPublished,
      'published_at': instance.publishedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'user': instance.user,
      'user_has_liked': instance.userHasLiked,
    };

CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) =>
    CreatePostRequest(
      title: json['title'] as String?,
      content: json['content'] as String,
      type: json['type'] as String? ?? 'text',
      media:
          (json['media'] as List<dynamic>?)?.map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CreatePostRequestToJson(CreatePostRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'type': instance.type,
      'media': instance.media,
      'metadata': instance.metadata,
    };
