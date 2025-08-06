import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'user_model.dart';

part 'connection_model.g.dart';

@JsonSerializable()
class Connection extends Equatable {
  final int id;
  @JsonKey(name: 'requester_id')
  final int requesterId;
  @JsonKey(name: 'addressee_id')
  final int addresseeId;
  final String status;
  final String? message;
  @JsonKey(name: 'accepted_at')
  final DateTime? acceptedAt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final User? requester;
  final User? addressee;

  const Connection({
    required this.id,
    required this.requesterId,
    required this.addresseeId,
    required this.status,
    this.message,
    this.acceptedAt,
    required this.createdAt,
    required this.updatedAt,
    this.requester,
    this.addressee,
  });

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);

  @override
  List<Object?> get props => [
        id,
        requesterId,
        addresseeId,
        status,
        message,
        acceptedAt,
        createdAt,
        updatedAt,
        requester,
        addressee,
      ];

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'accepted':
        return 'Aceptada';
      case 'declined':
        return 'Rechazada';
      case 'blocked':
        return 'Bloqueada';
      default:
        return 'Desconocido';
    }
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isDeclined => status == 'declined';
  bool get isBlocked => status == 'blocked';
}

@JsonSerializable()
class CreateConnectionRequest extends Equatable {
  @JsonKey(name: 'user_id')
  final int userId;
  final String? message;

  const CreateConnectionRequest({
    required this.userId,
    this.message,
  });

  factory CreateConnectionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateConnectionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateConnectionRequestToJson(this);

  @override
  List<Object?> get props => [userId, message];
}
