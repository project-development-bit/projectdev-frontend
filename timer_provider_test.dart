import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lib/features/auth/presentation/providers/resend_timer_provider.dart';

void main() {
  runApp(const ProviderScope(child: TimerTestApp()));
}

class TimerTestApp extends StatelessWidget {
  const TimerTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer Provider Test',
      home: const TimerTestPage(),
    );
  }
}

class TimerTestPage extends ConsumerWidget {
  const TimerTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canResend = ref.watch(canResendProvider);
    final countdown = ref.watch(countdownProvider);
    final isActive = ref.watch(isTimerActiveProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Provider Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Timer State:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text('Countdown: $countdown'),
            Text('Can Resend: $canResend'),
            Text('Is Active: $isActive'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(resendTimerProvider.notifier).startTimer();
              },
              child: const Text('Start Timer'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: canResend ? () {
                // Simulate resend code
                print('Resending code...');
                ref.read(resendTimerProvider.notifier).startTimer();
              } : null,
              child: Text(
                canResend 
                    ? 'Resend Code' 
                    : 'Resend in ${countdown}s',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(resendTimerProvider.notifier).resetTimer();
              },
              child: const Text('Reset Timer'),
            ),
          ],
        ),
      ),
    );
  }
}