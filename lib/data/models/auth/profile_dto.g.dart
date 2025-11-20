// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
  email: json['email'] as String,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'created_at': instance.createdAt,
    };
