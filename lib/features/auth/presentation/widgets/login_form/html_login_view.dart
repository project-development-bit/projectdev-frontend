import 'package:flutter/widgets.dart';

import 'html_email_password_view_stub.dart'
    if (dart.library.html) 'html_login_view_web.dart';

Widget buildEmailPasswordView({
  required void Function(String email, String password) onLogin,
}) =>
    getHtmlEmailPasswordView(onLogin: onLogin);

void requestLoginDataFromHtml() => requestEmailPasswordDataFromHtmlImpl();

void sendErrorsToHtml({String? emailError, String? passwordError}) =>
    sendErrorsToHtmlImpl(emailError: emailError, passwordError: passwordError);

void clearErrorsInHtml() => clearErrorsInHtmlImpl();
