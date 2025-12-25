import 'package:flutter/widgets.dart';

Widget getHtmlEmailPasswordView({
  required void Function(String email, String password) onLogin,
}) {
  return const Center(child: Text('HTML login is only available on Web'));
}

void requestEmailPasswordDataFromHtmlImpl() {}
void sendErrorsToHtmlImpl({String? emailError, String? passwordError}) {}

void clearErrorsInHtmlImpl() {}
