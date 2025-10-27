import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'internal_verification_overlay.dart';

/// Debug helper widget for internal verification management
/// This should only be used during development
class InternalVerificationDebugHelper extends ConsumerWidget {
  const InternalVerificationDebugHelper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVerified = ref.watch(internalVerificationProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bug_report,
                color: Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Internal Verification Debug',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${isVerified ? "✅ VERIFIED" : "❌ NOT VERIFIED"}',
            style: TextStyle(
              color: isVerified ? Colors.green : Colors.red,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Code: "2026"',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            'Enabled: ${true}', // Can be made dynamic later
            style: TextStyle(
              color: Colors.white60,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(internalVerificationProvider.notifier)
                      .markVerified();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(60, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 10),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  ref.read(internalVerificationProvider.notifier).reset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(60, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Extension to add debug helper to any widget
extension InternalVerificationDebug on Widget {
  /// Wraps the widget with debug helper (only in debug mode)
  Widget withInternalVerificationDebug() {
    return Stack(
      children: [
        this,
        Positioned(
          top: 100,
          right: 0,
          child: const InternalVerificationDebugHelper(),
        ),
      ],
    );
  }
}
