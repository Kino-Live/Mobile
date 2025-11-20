class UserProfile {
  final String email;
  final String? name;
  final String? phone;
  final DateTime? createdAt;

  const UserProfile({
    required this.email,
    this.name,
    this.phone,
    this.createdAt,
  });

  bool get hasName => name != null && name!.isNotEmpty;
  bool get hasPhone => phone != null && phone!.isNotEmpty;
}
