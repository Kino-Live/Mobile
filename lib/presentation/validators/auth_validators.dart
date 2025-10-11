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