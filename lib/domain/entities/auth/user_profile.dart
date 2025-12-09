class UserProfile {
  final String email;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? phoneNumber;
  final String? userRole;
  final String? profilePhotoUrl;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;

  const UserProfile({
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

  String? get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) return firstName;
    if (lastName != null) return lastName;
    return null;
  }

  bool get hasName => (firstName != null && firstName!.isNotEmpty) || 
                      (lastName != null && lastName!.isNotEmpty);
  bool get hasPhone => phoneNumber != null && phoneNumber!.isNotEmpty;
  bool get hasUsername => username != null && username!.isNotEmpty;

  UserProfile copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
    String? userRole,
    String? profilePhotoUrl,
    DateTime? dateOfBirth,
    DateTime? createdAt,
  }) {
    return UserProfile(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userRole: userRole ?? this.userRole,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
