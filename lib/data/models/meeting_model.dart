class MeetingModel {
  final int id;
  final int participantId;
  final String participantName;
  final String? participantCompany;
  final String? participantAvatar;
  final String whoProposed; // 'me' o 'them'
  final DateTime meetingDate;
  final String? location;
  final String? topicsDiscussed;
  final DateTime createdAt;
  final DateTime updatedAt;

  MeetingModel({
    required this.id,
    required this.participantId,
    required this.participantName,
    this.participantCompany,
    this.participantAvatar,
    required this.whoProposed,
    required this.meetingDate,
    this.location,
    this.topicsDiscussed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) {
    return MeetingModel(
      id: json['id'],
      participantId: json['participant_id'],
      participantName:
          json['participant_name'] ?? json['participant']?['name'] ?? 'Usuario',
      participantCompany: json['participant_company'] ??
          json['participant']?['company']?['name'],
      participantAvatar:
          json['participant_avatar'] ?? json['participant']?['avatar'],
      whoProposed: json['who_proposed'] ?? 'me',
      meetingDate:
          DateTime.parse(json['meeting_date'] ?? json['scheduled_date']),
      location: json['location'],
      topicsDiscussed: json['topics_discussed'] ?? json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant_id': participantId,
      'participant_name': participantName,
      'participant_company': participantCompany,
      'participant_avatar': participantAvatar,
      'who_proposed': whoProposed,
      'meeting_date': meetingDate.toIso8601String(),
      'location': location,
      'topics_discussed': topicsDiscussed,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  MeetingModel copyWith({
    int? id,
    int? participantId,
    String? participantName,
    String? participantCompany,
    String? participantAvatar,
    String? whoProposed,
    DateTime? meetingDate,
    String? location,
    String? topicsDiscussed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeetingModel(
      id: id ?? this.id,
      participantId: participantId ?? this.participantId,
      participantName: participantName ?? this.participantName,
      participantCompany: participantCompany ?? this.participantCompany,
      participantAvatar: participantAvatar ?? this.participantAvatar,
      whoProposed: whoProposed ?? this.whoProposed,
      meetingDate: meetingDate ?? this.meetingDate,
      location: location ?? this.location,
      topicsDiscussed: topicsDiscussed ?? this.topicsDiscussed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get whoProposedText =>
      whoProposed == 'me' ? 'Yo propuse' : 'Ellos propusieron';
}
