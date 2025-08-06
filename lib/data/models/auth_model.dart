import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'user_model.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  List<Object?> get props => [email, password];
}

@JsonSerializable()
class RegisterRequest extends Equatable {
  final String name;
  final String email;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  final String? phone;
  final String? position;
  @JsonKey(name: 'company_id')
  final int? companyId;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phone,
    this.position,
    this.companyId,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        passwordConfirmation,
        phone,
        position,
        companyId,
      ];
}

@JsonSerializable()
class AuthResponse extends Equatable {
  final String message;
  final User user;
  final String token;

  const AuthResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  List<Object?> get props => [message, user, token];
}

@JsonSerializable()
class ProfileStats extends Equatable {
  @JsonKey(name: 'profile_completion')
  final int profileCompletion;
  @JsonKey(name: 'connections_count')
  final int connectionsCount;
  @JsonKey(name: 'posts_count')
  final int postsCount;
  @JsonKey(name: 'events_created')
  final int eventsCreated;
  @JsonKey(name: 'events_attended')
  final int eventsAttended;
  @JsonKey(name: 'membership_status')
  final String membershipStatus;
  @JsonKey(name: 'is_active_member')
  final bool isActiveMember;
  @JsonKey(name: 'membership_expiring')
  final bool membershipExpiring;
  @JsonKey(name: 'days_until_renewal')
  final int? daysUntilRenewal;

  const ProfileStats({
    required this.profileCompletion,
    required this.connectionsCount,
    required this.postsCount,
    required this.eventsCreated,
    required this.eventsAttended,
    required this.membershipStatus,
    required this.isActiveMember,
    required this.membershipExpiring,
    this.daysUntilRenewal,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatsFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileStatsToJson(this);

  @override
  List<Object?> get props => [
        profileCompletion,
        connectionsCount,
        postsCount,
        eventsCreated,
        eventsAttended,
        membershipStatus,
        isActiveMember,
        membershipExpiring,
        daysUntilRenewal,
      ];
}
