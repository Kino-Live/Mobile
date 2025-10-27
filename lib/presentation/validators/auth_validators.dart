class AuthValidators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter your email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? passwordMin6(String? v) {
    if (v == null || v.length < 6) return 'Min 6 characters';
    return null;
  }
}

String maskEmail(String email) {
  final atIndex = email.indexOf('@');
  if (atIndex <= 1) return email;

  final name = email.substring(0, atIndex);
  final domain = email.substring(atIndex);

  return name.length <= 4
      ? '${name[0]}...$domain'
      : '${name.substring(0, 4)}...$domain';
}
