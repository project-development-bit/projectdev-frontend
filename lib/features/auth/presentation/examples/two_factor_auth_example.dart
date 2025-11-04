import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Example widget demonstrating how to use the 2FA dialog
/// This can be used in login flow or any place where 2FA verification is needed
class TwoFactorAuthExample extends ConsumerWidget {
  const TwoFactorAuthExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2FA Dialog Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '2FA Verification Dialog Example',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Click the button below to see the 2FA dialog in action',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CommonButton(
                text: 'Show 2FA Dialog',
                onPressed: () async {
                  // Show the 2FA dialog
                  final result = await context.show2FAVerificationDialog(
                    email: 'user@example.com',
                    sessionToken: 'optional-session-token',
                    onSuccess: () {
                      // This callback is called when verification succeeds
                      debugPrint('✅ 2FA verification successful!');
                      
                      // Navigate to home or next screen
                      context.goToHome();
                    },
                  );

                  // Handle the result
                  if (result == true) {
                    debugPrint('✅ Dialog returned success');
                  } else {
                    debugPrint('❌ Dialog was dismissed or verification failed');
                    context.showErrorSnackBar(
                      message: '2FA verification was cancelled',
                    );
                  }
                },
                height: 56,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                'Integration Example:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '''// In your login flow:
if (loginResponse.requires2FA) {
  await context.show2FAVerificationDialog(
    email: email,
    sessionToken: loginResponse.sessionToken,
    onSuccess: () {
      context.goToHome();
    },
  );
}''',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
