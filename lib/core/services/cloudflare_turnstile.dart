// import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final turnstileServiceProvider = Provider<TurnstileService>(
//   (ref) => TurnstileService(),
// );


// class TurnstileService {
//   /// Retrives the CloudFlare Turnstile token using invisible mode.
//   static Future<String?> get token async {
//     // Initialize an instance of invisible Cloudflare Turnstile with your site key
//     final turnstile = CloudflareTurnstile.invisible(
//       siteKey: '0x4AAAAAAB-h_zqcfZnriGXu', // Replace with your actual site key
//     );

//     try {
//       // Get the Turnstile token
//       final token = await turnstile.getToken();
//       return token; // Return the token upon success
//     } on TurnstileException catch (e) {
//       // Handle Turnstile failure
//       print('Challenge failed: ${e.message}');
//     } finally {
//       // Ensure the Turnstile instance is properly disposed of
//       turnstile.dispose();
//     }

//     // Return null if the token couldn't be generated
//     return null;
//   }
// }