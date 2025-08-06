// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] == null
          ? null
          : DateTime.parse(json['email_verified_at'] as String),
      phone: json['phone'] as String?,
      directPhone: json['direct_phone'] as String?,
      fax: json['fax'] as String?,
      tollFreePhone: json['toll_free_phone'] as String?,
      position: json['position'] as String?,
      specialty: json['specialty'] as String?,
      professionalGroup: json['professional_group'] as String?,
      bio: json['bio'] as String?,
      businessDescription: json['business_description'] as String?,
      linkedinUrl: json['linkedin_url'] as String?,
      websiteUrl: json['website_url'] as String?,
      avatar: json['avatar'] as String?,
      location: json['location'] as String?,
      taxAddress: json['tax_address'] as String?,
      taxId: json['tax_id'] as String?,
      taxIdType: json['tax_id_type'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isActive: json['is_active'] as bool,
      membershipStatus: json['membership_status'] as String,
      membershipRenewalDate: json['membership_renewal_date'] == null
          ? null
          : DateTime.parse(json['membership_renewal_date'] as String),
      profileCompleted: json['profile_completed'] as bool,
      companyId: (json['company_id'] as num?)?.toInt(),
      company: json['company'] == null
          ? null
          : Company.fromJson(json['company'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
      'phone': instance.phone,
      'direct_phone': instance.directPhone,
      'fax': instance.fax,
      'toll_free_phone': instance.tollFreePhone,
      'position': instance.position,
      'specialty': instance.specialty,
      'professional_group': instance.professionalGroup,
      'bio': instance.bio,
      'business_description': instance.businessDescription,
      'linkedin_url': instance.linkedinUrl,
      'website_url': instance.websiteUrl,
      'avatar': instance.avatar,
      'location': instance.location,
      'tax_address': instance.taxAddress,
      'tax_id': instance.taxId,
      'tax_id_type': instance.taxIdType,
      'skills': instance.skills,
      'interests': instance.interests,
      'keywords': instance.keywords,
      'is_active': instance.isActive,
      'membership_status': instance.membershipStatus,
      'membership_renewal_date':
          instance.membershipRenewalDate?.toIso8601String(),
      'profile_completed': instance.profileCompleted,
      'company_id': instance.companyId,
      'company': instance.company,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
