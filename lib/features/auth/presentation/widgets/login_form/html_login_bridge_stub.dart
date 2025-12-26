class HtmlLoginRegistry {
  static void init({
    required void Function(String email, String password) onLogin,
  }) {}

  static void requestLogin() {}

  static void restore() {}

  static void showErrors({String? emailError, String? passwordError}) {}

  static void clearErrors() {}
}
