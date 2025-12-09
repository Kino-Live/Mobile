import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
class ProfileDto {
  final String email;
  
  @JsonKey(name: 'first_name')
  final String? firstName;
  
  @JsonKey(name: 'last_name')
  final String? lastName;
  
  final String? username;
  
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  
  @JsonKey(name: 'user_role')
  final String? userRole;
  
  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;
  
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  const ProfileDto({
    required this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.phoneNumber,
    this.userRole,
    this.profilePhotoUrl,
    this.dateOfBirth,
    this.createdAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}
