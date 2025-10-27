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
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Error: ${verificationState.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (verificationState is VerificationSuccess)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Success: ${verificationState.message}',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            if (verificationState is ResendCodeSuccess)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Resend Success: ${verificationState.message}',
                  style: const TextStyle(color: Colors.blue),
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
