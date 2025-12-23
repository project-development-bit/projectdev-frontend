import 'package:url_launcher/url_launcher.dart';

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
    return await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
