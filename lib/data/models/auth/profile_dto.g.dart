// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
  email: json['email'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  username: json['username'] as String?,
  phoneNumber: json['phone_number'] as String?,
  userRole: json['user_role'] as String?,
  profilePhotoUrl: json['profile_photo_url'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'username': instance.username,
      'phone_number': instance.phoneNumber,
      'user_role': instance.userRole,
      'profile_photo_url': instance.profilePhotoUrl,
      'date_of_birth': instance.dateOfBirth,
      'created_at': instance.createdAt,
    };
