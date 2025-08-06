import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'user_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class Post extends Equatable {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String? title;
  final String content;
  final String type;
  final List<String>? media;
  final Map<String, dynamic>? metadata;
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @JsonKey(name: 'comments_count')
  final int commentsCount;
  @JsonKey(name: 'shares_count')
  final int sharesCount;
  @JsonKey(name: 'is_published')
  final bool isPublished;
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User? user;
  @JsonKey(name: 'user_has_liked')
  final bool? userHasLiked;

  const Post({
    required this.id,
    required this.userId,
    this.title,
    required this.content,
    required this.type,
    this.media,
    this.metadata,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.isPublished,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.userHasLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        content,
        type,
        media,
        metadata,
        likesCount,
        commentsCount,
        sharesCount,
        isPublished,
        publishedAt,
        createdAt,
        updatedAt,
        user,
        userHasLiked,
      ];

  String get typeText {
    switch (type) {
      case 'text':
        return 'Texto';
      case 'image':
        return 'Imagen';
      case 'video':
        return 'Video';
      case 'link':
        return 'Enlace';
      case 'job':
        return 'Oferta de Trabajo';
      case 'event':
        return 'Evento';
      default:
        return 'Publicación';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }

  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? content,
    String? type,
    List<String>? media,
    Map<String, dynamic>? metadata,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isPublished,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    bool? userHasLiked,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      media: media ?? this.media,
      metadata: metadata ?? this.metadata,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      userHasLiked: userHasLiked ?? this.userHasLiked,
    );
  }
}

@JsonSerializable()
class CreatePostRequest extends Equatable {
  final String? title;
  final String content;
  final String type;
  final List<String>? media;
  final Map<String, dynamic>? metadata;

  const CreatePostRequest({
    this.title,
    required this.content,
    this.type = 'text',
    this.media,
    this.metadata,
  });

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);

  @override
  List<Object?> get props => [title, content, type, media, metadata];
}
