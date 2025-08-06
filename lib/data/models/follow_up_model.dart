class FollowUpModel {
  final int id;
  final int meetingId;
  final String participantName;
  final String? participantCompany;
  final DateTime followUpDate;
  final String? followUpNotes;
  final String? actionItems;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  FollowUpModel({
    required this.id,
    required this.meetingId,
    required this.participantName,
    this.participantCompany,
    required this.followUpDate,
    this.followUpNotes,
    this.actionItems,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FollowUpModel.fromJson(Map<String, dynamic> json) {
    return FollowUpModel(
      id: json['id'],
      meetingId: json['meeting_id'],
      participantName: json['participant_name'] ??
          json['meeting']?['participant']?['name'] ??
          'Usuario',
      participantCompany: json['participant_company'] ??
          json['meeting']?['participant']?['company']?['name'],
      followUpDate: DateTime.parse(json['follow_up_date']),
      followUpNotes: json['follow_up_notes'],
      actionItems: json['action_items'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meeting_id': meetingId,
      'participant_name': participantName,
      'participant_company': participantCompany,
      'follow_up_date': followUpDate.toIso8601String(),
      'follow_up_notes': followUpNotes,
      'action_items': actionItems,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FollowUpModel copyWith({
    int? id,
    int? meetingId,
    String? participantName,
    String? participantCompany,
    DateTime? followUpDate,
    String? followUpNotes,
    String? actionItems,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FollowUpModel(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      participantName: participantName ?? this.participantName,
      participantCompany: participantCompany ?? this.participantCompany,
      followUpDate: followUpDate ?? this.followUpDate,
      followUpNotes: followUpNotes ?? this.followUpNotes,
      actionItems: actionItems ?? this.actionItems,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
