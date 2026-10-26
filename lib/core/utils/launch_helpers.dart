class LaunchHelpers {
  LaunchHelpers._();

  static String digitsOnly(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  static String whatsappNumber(String phone) {
    final digits = digitsOnly(phone);
    if (digits.length == 10) return '91$digits';
    return digits;
  }
}
