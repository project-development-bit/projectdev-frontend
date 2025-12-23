import 'package:web/web.dart' as web;

const String kSupportEmailAddress = 'projectdev.bit@gmail.com';

Future<bool> launchSupportEmail({String? subject, String? body}) async {
  final emailUri = Uri(
    scheme: 'mailto',
    path: kSupportEmailAddress,
    queryParameters: <String, String>{
      if (subject != null && subject.isNotEmpty) 'subject': subject,
      if (body != null && body.isNotEmpty) 'body': body,
    },
  );

  try {
    final href = emailUri.toString();
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = href
      ..target = '_self'
      ..style.display = 'none';

    web.document.body?.appendChild(anchor);
    anchor.click();
    anchor.remove();

    // Some environments ignore synthetic clicks; fall back to location.
    web.window.location.assign(href);
    return true;
  } catch (_) {
    return false;
  }
}
