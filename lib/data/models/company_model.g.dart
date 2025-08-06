// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      companyDescription: json['company_description'] as String?,
      industry: json['industry'] as String,
      size: json['size'] as String,
      employeesCount: (json['employees_count'] as num?)?.toInt(),
      foundedYear: (json['founded_year'] as num?)?.toInt(),
      website: json['website'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fax: json['fax'] as String?,
      tollFreePhone: json['toll_free_phone'] as String?,
      taxId: json['tax_id'] as String?,
      taxAddress: json['tax_address'] as String?,
      logo: json['logo'] as String?,
      coverImage: json['cover_image'] as String?,
      address: json['address'] as Map<String, dynamic>?,
      socialLinks: json['social_links'] as Map<String, dynamic>?,
      businessHours: json['business_hours'] as Map<String, dynamic>?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      membershipType: json['membership_type'] as String,
      membershipStartDate: json['membership_start_date'] == null
          ? null
          : DateTime.parse(json['membership_start_date'] as String),
      membershipEndDate: json['membership_end_date'] == null
          ? null
          : DateTime.parse(json['membership_end_date'] as String),
      membershipStatus: json['membership_status'] as String,
      isVerified: json['is_verified'] as bool,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'company_description': instance.companyDescription,
      'industry': instance.industry,
      'size': instance.size,
      'employees_count': instance.employeesCount,
      'founded_year': instance.foundedYear,
      'website': instance.website,
      'email': instance.email,
      'phone': instance.phone,
      'fax': instance.fax,
      'toll_free_phone': instance.tollFreePhone,
      'tax_id': instance.taxId,
      'tax_address': instance.taxAddress,
      'logo': instance.logo,
      'cover_image': instance.coverImage,
      'address': instance.address,
      'social_links': instance.socialLinks,
      'business_hours': instance.businessHours,
      'services': instance.services,
      'membership_type': instance.membershipType,
      'membership_start_date': instance.membershipStartDate?.toIso8601String(),
      'membership_end_date': instance.membershipEndDate?.toIso8601String(),
      'membership_status': instance.membershipStatus,
      'is_verified': instance.isVerified,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
