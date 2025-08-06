import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'company_model.g.dart';

@JsonSerializable()
class Company extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? description;
  @JsonKey(name: 'company_description')
  final String? companyDescription;
  final String industry;
  final String size;
  @JsonKey(name: 'employees_count')
  final int? employeesCount;
  @JsonKey(name: 'founded_year')
  final int? foundedYear;
  final String? website;
  final String? email;
  final String? phone;
  final String? fax;
  @JsonKey(name: 'toll_free_phone')
  final String? tollFreePhone;
  @JsonKey(name: 'tax_id')
  final String? taxId;
  @JsonKey(name: 'tax_address')
  final String? taxAddress;
  final String? logo;
  @JsonKey(name: 'cover_image')
  final String? coverImage;
  final Map<String, dynamic>? address;
  @JsonKey(name: 'social_links')
  final Map<String, dynamic>? socialLinks;
  @JsonKey(name: 'business_hours')
  final Map<String, dynamic>? businessHours;
  final List<String>? services;
  @JsonKey(name: 'membership_type')
  final String membershipType;
  @JsonKey(name: 'membership_start_date')
  final DateTime? membershipStartDate;
  @JsonKey(name: 'membership_end_date')
  final DateTime? membershipEndDate;
  @JsonKey(name: 'membership_status')
  final String membershipStatus;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Company({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.companyDescription,
    required this.industry,
    required this.size,
    this.employeesCount,
    this.foundedYear,
    this.website,
    this.email,
    this.phone,
    this.fax,
    this.tollFreePhone,
    this.taxId,
    this.taxAddress,
    this.logo,
    this.coverImage,
    this.address,
    this.socialLinks,
    this.businessHours,
    this.services,
    required this.membershipType,
    this.membershipStartDate,
    this.membershipEndDate,
    required this.membershipStatus,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        companyDescription,
        industry,
        size,
        employeesCount,
        foundedYear,
        website,
        email,
        phone,
        fax,
        tollFreePhone,
        taxId,
        taxAddress,
        logo,
        coverImage,
        address,
        socialLinks,
        businessHours,
        services,
        membershipType,
        membershipStartDate,
        membershipEndDate,
        membershipStatus,
        isVerified,
        isActive,
        createdAt,
        updatedAt,
      ];

  // Helper methods
  String get displayDescription => companyDescription ?? description ?? '';

  bool get isActiveMember =>
      membershipStatus == 'active' &&
      membershipEndDate != null &&
      membershipEndDate!.isAfter(DateTime.now());

  bool get isMembershipExpiring {
    if (membershipEndDate == null) return false;
    final daysUntilExpiry =
        membershipEndDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30;
  }

  String get membershipTypeText {
    switch (membershipType) {
      case 'basic':
        return 'Básica';
      case 'premium':
        return 'Premium';
      case 'enterprise':
        return 'Empresarial';
      default:
        return 'Desconocida';
    }
  }

  String get sizeText {
    switch (size) {
      case 'startup':
        return 'Startup';
      case 'small':
        return 'Pequeña';
      case 'medium':
        return 'Mediana';
      case 'large':
        return 'Grande';
      case 'enterprise':
        return 'Corporativa';
      default:
        return 'No especificado';
    }
  }

  String get fullAddress {
    if (address == null) return '';
    final parts = <String>[];
    if (address!['street'] != null) parts.add(address!['street']);
    if (address!['city'] != null) parts.add(address!['city']);
    if (address!['postal_code'] != null) parts.add(address!['postal_code']);
    if (address!['country'] != null) parts.add(address!['country']);
    return parts.join(', ');
  }
}
