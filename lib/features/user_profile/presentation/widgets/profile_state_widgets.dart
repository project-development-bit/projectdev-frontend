import 'package:flutter/material.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Profile loading state widget
class ProfileLoadingWidget extends StatelessWidget {
  const ProfileLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.primary,
      ),
    );
  }
}

/// Profile error state widget
class ProfileErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const ProfileErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.error,
          ),
          const SizedBox(height: 16),
          CommonText.bodyMedium(
            error,
            color: context.onSurface,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
              ),
              child: CommonText.bodyMedium('Retry'),
            ),
        ],
      ),
    );
  }
}

/// Profile empty state widget
class ProfileEmptyWidget extends StatelessWidget {
  const ProfileEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CommonText.bodyMedium(
        'Profile not found',
        color: context.onSurface,
      ),
    );
  }
}