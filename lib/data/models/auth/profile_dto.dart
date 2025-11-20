import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
class ProfileDto {
  final String email;
  final String? name;
  final String? phone;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  const ProfileDto({
    required this.email,
    this.name,
    this.phone,
    this.createdAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDtoToJson(this);
}
