import 'package:flutter/widgets.dart';

import 'html_login_bridge_stub.dart'
    if (dart.library.html) 'html_login_bridge_web.dart';

typedef HtmlLoginCallback = void Function(String email, String password);

Widget buildHtmlLoginView({
  required void Function(String email, String password) onLogin,
}) {
  HtmlLoginRegistry.init(onLogin: onLogin);
  return const HtmlElementView(viewType: 'html-login');
}

void requestLoginDataFromHtml() => HtmlLoginRegistry.requestLogin();

void sendErrorsToHtml({String? emailError, String? passwordError}) =>
    HtmlLoginRegistry.showErrors(
        emailError: emailError, passwordError: passwordError);

void clearErrorsInHtml() => HtmlLoginRegistry.clearErrors();

void restoreDataToHtml() => HtmlLoginRegistry.restore();
