import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'company_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  final String? phone;
  @JsonKey(name: 'direct_phone')
  final String? directPhone;
  final String? fax;
  @JsonKey(name: 'toll_free_phone')
  final String? tollFreePhone;
  final String? position;
  final String? specialty;
  @JsonKey(name: 'professional_group')
  final String? professionalGroup;
  final String? bio;
  @JsonKey(name: 'business_description')
  final String? businessDescription;
  @JsonKey(name: 'linkedin_url')
  final String? linkedinUrl;
  @JsonKey(name: 'website_url')
  final String? websiteUrl;
  final String? avatar;
  final String? location;
  @JsonKey(name: 'tax_address')
  final String? taxAddress;
  @JsonKey(name: 'tax_id')
  final String? taxId;
  @JsonKey(name: 'tax_id_type')
  final String? taxIdType;
  final List<String>? skills;
  final List<String>? interests;
  final List<String>? keywords;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'membership_status')
  final String membershipStatus;
  @JsonKey(name: 'membership_renewal_date')
  final DateTime? membershipRenewalDate;
  @JsonKey(name: 'profile_completed')
  final bool profileCompleted;
  @JsonKey(name: 'company_id')
  final int? companyId;
  final Company? company;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.phone,
    this.directPhone,
    this.fax,
    this.tollFreePhone,
    this.position,
    this.specialty,
    this.professionalGroup,
    this.bio,
    this.businessDescription,
    this.linkedinUrl,
    this.websiteUrl,
    this.avatar,
    this.location,
    this.taxAddress,
    this.taxId,
    this.taxIdType,
    this.skills,
    this.interests,
    this.keywords,
    required this.isActive,
    required this.membershipStatus,
    this.membershipRenewalDate,
    required this.profileCompleted,
    this.companyId,
    this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserFromJson(json);
    } catch (e) {
      // Si hay un error en la deserialización, crear un usuario con valores por defecto
      return User(
        id: json['id'] ?? 0,
        name: json['name'] ?? 'Usuario',
        email: json['email'] ?? '',
        emailVerifiedAt: json['email_verified_at'] != null
            ? DateTime.tryParse(json['email_verified_at'])
            : null,
        phone: json['phone'],
        directPhone: json['direct_phone'],
        fax: json['fax'],
        tollFreePhone: json['toll_free_phone'],
        position: json['position'],
        specialty: json['specialty'],
        professionalGroup: json['professional_group'],
        bio: json['bio'],
        businessDescription: json['business_description'],
        linkedinUrl: json['linkedin_url'],
        websiteUrl: json['website_url'],
        avatar: json['avatar'],
        location: json['location'],
        taxAddress: json['tax_address'],
        taxId: json['tax_id'],
        taxIdType: json['tax_id_type'],
        skills:
            json['skills'] != null ? List<String>.from(json['skills']) : null,
        interests: json['interests'] != null
            ? List<String>.from(json['interests'])
            : null,
        keywords: json['keywords'] != null
            ? List<String>.from(json['keywords'])
            : null,
        isActive: json['is_active'] ?? true,
        membershipStatus: json['membership_status'] ?? 'inactive',
        membershipRenewalDate: json['membership_renewal_date'] != null
            ? DateTime.tryParse(json['membership_renewal_date'])
            : null,
        profileCompleted: json['profile_completed'] ?? false,
        companyId: json['company_id'],
        company:
            json['company'] != null ? Company.fromJson(json['company']) : null,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at']) ?? DateTime.now()
            : DateTime.now(),
      );
    }
  }
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        emailVerifiedAt,
        phone,
        directPhone,
        fax,
        tollFreePhone,
        position,
        specialty,
        professionalGroup,
        bio,
        businessDescription,
        linkedinUrl,
        websiteUrl,
        avatar,
        location,
        taxAddress,
        taxId,
        taxIdType,
        skills,
        interests,
        keywords,
        isActive,
        membershipStatus,
        membershipRenewalDate,
        profileCompleted,
        companyId,
        company,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? phone,
    String? directPhone,
    String? fax,
    String? tollFreePhone,
    String? position,
    String? specialty,
    String? professionalGroup,
    String? bio,
    String? businessDescription,
    String? linkedinUrl,
    String? websiteUrl,
    String? avatar,
    String? location,
    String? taxAddress,
    String? taxId,
    String? taxIdType,
    List<String>? skills,
    List<String>? interests,
    List<String>? keywords,
    bool? isActive,
    String? membershipStatus,
    DateTime? membershipRenewalDate,
    bool? profileCompleted,
    int? companyId,
    Company? company,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phone: phone ?? this.phone,
      directPhone: directPhone ?? this.directPhone,
      fax: fax ?? this.fax,
      tollFreePhone: tollFreePhone ?? this.tollFreePhone,
      position: position ?? this.position,
      specialty: specialty ?? this.specialty,
      professionalGroup: professionalGroup ?? this.professionalGroup,
      bio: bio ?? this.bio,
      businessDescription: businessDescription ?? this.businessDescription,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      taxAddress: taxAddress ?? this.taxAddress,
      taxId: taxId ?? this.taxId,
      taxIdType: taxIdType ?? this.taxIdType,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      keywords: keywords ?? this.keywords,
      isActive: isActive ?? this.isActive,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      membershipRenewalDate:
          membershipRenewalDate ?? this.membershipRenewalDate,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      companyId: companyId ?? this.companyId,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  String get displayName => name;

  String get fullContactInfo {
    final contacts = <String>[];
    if (phone != null) contacts.add('Tel: $phone');
    if (directPhone != null) contacts.add('Directo: $directPhone');
    if (email.isNotEmpty) contacts.add('Email: $email');
    return contacts.join(' • ');
  }

  bool get isActiveMember => membershipStatus == 'active';

  bool get isMembershipExpiring {
    if (membershipRenewalDate == null) return false;
    final daysUntilRenewal =
        membershipRenewalDate!.difference(DateTime.now()).inDays;
    return daysUntilRenewal <= 30;
  }

  String get membershipStatusText {
    switch (membershipStatus) {
      case 'active':
        return 'Activo';
      case 'inactive':
        return 'Inactivo';
      case 'pending':
        return 'Pendiente';
      case 'suspended':
        return 'Suspendido';
      default:
        return 'Desconocido';
    }
  }

  // Getters de compatibilidad para la pantalla de perfil
  String? get linkedinProfile => linkedinUrl;
  String? get website => websiteUrl;
}

// Alias para mantener consistencia en el código
typedef UserModel = User;
