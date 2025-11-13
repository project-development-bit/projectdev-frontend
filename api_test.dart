import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/features/auth/presentation/providers/verification_provider.dart';

void main() {
  runApp(const ProviderScope(child: ApiTestApp()));
}

class ApiTestApp extends StatelessWidget {
  const ApiTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Endpoint Test',
      home: const ApiTestPage(),
    );
  }
}

class ApiTestPage extends ConsumerWidget {
  const ApiTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verificationState = ref.watch(verificationNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Endpoint Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Current State: ${verificationState.runtimeType}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            if (verificationState is VerificationError)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.onError.withValues(alpha: 0.1),
                  border: Border.all(color: colorScheme.error),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Error: ${verificationState.message}',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            if (verificationState is VerificationSuccess)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSuccess.withValues(alpha: 0.1)
                      : AppColors.lightSuccess.withValues(alpha: 0.1),
                  border: Border.all(
                      color: isDark
                          ? AppColors.darkSuccess
                          : AppColors.lightSuccess),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Success: ${verificationState.message}',
                  style: TextStyle(
                      color: isDark
                          ? AppColors.darkSuccess
                          : AppColors.lightSuccess),
                ),
              ),
            if (verificationState is ResendCodeSuccess)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkInfo.withValues(alpha: 0.1)
                      : AppColors.lightInfo.withValues(alpha: 0.1),
                  border: Border.all(
                      color: isDark ? AppColors.darkInfo : AppColors.lightInfo),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Resend Success: ${verificationState.message}',
                  style: TextStyle(
                      color: isDark ? AppColors.darkInfo : AppColors.lightInfo),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificationState is VerificationLoading
                  ? null
                  : () {
                      ref
                          .read(verificationNotifierProvider.notifier)
                          .resendCode(
                            email: 'test@example.com',
                          );
                    },
              child: verificationState is VerificationLoading
                  ? const CircularProgressIndicator()
                  : const Text('Test Resend Code'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: verificationState is VerificationLoading
                  ? null
                  : () {
                      ref
                          .read(verificationNotifierProvider.notifier)
                          .verifyCode(
                            email: 'test@example.com',
                            code: '1234',
                          );
                    },
              child: verificationState is VerificationLoading
                  ? const CircularProgressIndicator()
                  : const Text('Test Verify Code'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Check the debug console for detailed API call logs.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
