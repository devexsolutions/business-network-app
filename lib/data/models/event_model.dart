import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'user_model.dart';
import 'company_model.dart';

part 'event_model.g.dart';

// Alias para mantener consistencia con el resto de la aplicación
typedef EventModel = Event;

@JsonSerializable()
class Event extends Equatable {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'company_id')
  final int? companyId;
  final String title;
  final String description;
  final String type;
  final String format;
  final Map<String, dynamic>? location;
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @JsonKey(name: 'max_attendees')
  final int? maxAttendees;
  final double price;
  final String? image;
  final List<String>? tags;
  @JsonKey(name: 'is_published')
  final bool isPublished;
  @JsonKey(name: 'requires_approval')
  final bool requiresApproval;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User? user;
  final Company? company;
  @JsonKey(name: 'user_is_attending')
  final bool? userIsAttending;
  @JsonKey(name: 'attendees_count')
  final int? attendeesCount;

  const Event({
    required this.id,
    required this.userId,
    this.companyId,
    required this.title,
    required this.description,
    required this.type,
    required this.format,
    this.location,
    required this.startDate,
    required this.endDate,
    this.maxAttendees,
    required this.price,
    this.image,
    this.tags,
    required this.isPublished,
    required this.requiresApproval,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.company,
    this.userIsAttending,
    this.attendeesCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        companyId,
        title,
        description,
        type,
        format,
        location,
        startDate,
        endDate,
        maxAttendees,
        price,
        image,
        tags,
        isPublished,
        requiresApproval,
        createdAt,
        updatedAt,
        user,
        company,
        userIsAttending,
        attendeesCount,
      ];

  String get typeText {
    switch (type) {
      case 'networking':
        return 'Networking';
      case 'conference':
        return 'Conferencia';
      case 'workshop':
        return 'Taller';
      case 'webinar':
        return 'Webinar';
      default:
        return 'Evento';
    }
  }

  String get formatText {
    switch (format) {
      case 'in_person':
        return 'Presencial';
      case 'virtual':
        return 'Virtual';
      case 'hybrid':
        return 'Híbrido';
      default:
        return 'No especificado';
    }
  }

  bool get isUpcoming => startDate.isAfter(DateTime.now());
  bool get isPast => endDate.isBefore(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(startDate.year, startDate.month, startDate.day);
    return today == eventDay;
  }

  String get locationText {
    if (location == null) return 'Ubicación no especificada';

    if (format == 'virtual') {
      return location!['link'] ?? 'Enlace virtual';
    } else {
      final address = location!['address'] ?? '';
      final city = location!['city'] ?? '';
      return '$address${city.isNotEmpty ? ', $city' : ''}';
    }
  }

  bool get hasAvailableSpots {
    if (maxAttendees == null) return true;
    return (attendeesCount ?? 0) < maxAttendees!;
  }

  String get priceText {
    if (price == 0) return 'Gratis';
    return '€${price.toStringAsFixed(2)}';
  }

  // Métodos adicionales para compatibilidad con la UI
  DateTime get eventDate => startDate;
  String? get locationString => locationText;
  bool get isRegistered => userIsAttending ?? false;

  Event copyWith({
    int? id,
    int? userId,
    int? companyId,
    String? title,
    String? description,
    String? type,
    String? format,
    Map<String, dynamic>? locationData,
    DateTime? startDate,
    DateTime? endDate,
    int? maxAttendees,
    double? price,
    String? image,
    List<String>? tags,
    bool? isPublished,
    bool? requiresApproval,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    Company? company,
    bool? userIsAttending,
    int? attendeesCount,
    bool? isRegistered,
  }) {
    return Event(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      format: format ?? this.format,
      location: locationData ?? location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      price: price ?? this.price,
      image: image ?? this.image,
      tags: tags ?? this.tags,
      isPublished: isPublished ?? this.isPublished,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      company: company ?? this.company,
      userIsAttending: isRegistered ?? userIsAttending ?? this.userIsAttending,
      attendeesCount: attendeesCount ?? this.attendeesCount,
    );
  }
}
