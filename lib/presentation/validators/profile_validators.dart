class ProfileValidators {
  static String? name(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter your name';
    if (v.trim().length < 2) return 'Name looks too short';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter your phone';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7) return 'Phone looks too short';
    return null;
  }
}
