// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['password_confirmation'] as String,
      phone: json['phone'] as String?,
      position: json['position'] as String?,
      companyId: (json['company_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'password_confirmation': instance.passwordConfirmation,
      'phone': instance.phone,
      'position': instance.position,
      'company_id': instance.companyId,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      message: json['message'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
      'token': instance.token,
    };

ProfileStats _$ProfileStatsFromJson(Map<String, dynamic> json) => ProfileStats(
      profileCompletion: (json['profile_completion'] as num).toInt(),
      connectionsCount: (json['connections_count'] as num).toInt(),
      postsCount: (json['posts_count'] as num).toInt(),
      eventsCreated: (json['events_created'] as num).toInt(),
      eventsAttended: (json['events_attended'] as num).toInt(),
      membershipStatus: json['membership_status'] as String,
      isActiveMember: json['is_active_member'] as bool,
      membershipExpiring: json['membership_expiring'] as bool,
      daysUntilRenewal: (json['days_until_renewal'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProfileStatsToJson(ProfileStats instance) =>
    <String, dynamic>{
      'profile_completion': instance.profileCompletion,
      'connections_count': instance.connectionsCount,
      'posts_count': instance.postsCount,
      'events_created': instance.eventsCreated,
      'events_attended': instance.eventsAttended,
      'membership_status': instance.membershipStatus,
      'is_active_member': instance.isActiveMember,
      'membership_expiring': instance.membershipExpiring,
      'days_until_renewal': instance.daysUntilRenewal,
    };
