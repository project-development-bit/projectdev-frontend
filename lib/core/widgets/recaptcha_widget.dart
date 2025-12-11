import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/common_text.dart';
import '../extensions/context_extensions.dart';
import '../providers/recaptcha_provider.dart';
import '../services/platform_recaptcha_service.dart';
import '../../features/localization/data/helpers/app_localizations.dart';

/// A platform-aware widget that provides reCAPTCHA verification functionality
class RecaptchaWidget extends ConsumerWidget {
  const RecaptchaWidget({
    super.key,
    this.onVerificationChanged,
    this.enabled = true,
    this.action = 'login',
  });

  /// Callback when verification status changes (optional, can use providers instead)
  final ValueChanged<bool>? onVerificationChanged;

  /// Whether the widget is enabled
  final bool enabled;

  /// The reCAPTCHA action to perform (login, signup, etc.)
  final String action;

  void _handleVerificationChanged(WidgetRef ref, bool isVerified) {
    // Call callback if provided for backward compatibility
    onVerificationChanged?.call(isVerified);
  }

  void _handleVerify(WidgetRef ref) {
    if (!enabled) return;

    final notifier = ref.read(recaptchaNotifierProvider.notifier);
    debugPrint(
        'reCAPTCHA Widget: Triggering verify() for action: $action on ${PlatformRecaptchaService.platformName}');
    notifier.verify(action: action);
  }

  void _handleReset(WidgetRef ref) {
    final notifier = ref.read(recaptchaNotifierProvider.notifier);
    debugPrint(
        'reCAPTCHA Widget: Triggering reset() on ${PlatformRecaptchaService.platformName}');
    notifier.reset();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recaptchaState = ref.watch(recaptchaNotifierProvider);
    final isRequired = ref.watch(isRecaptchaRequiredProvider);
    final isVerified = ref.watch(isRecaptchaVerifiedProvider);
    final isLoading = ref.watch(isRecaptchaLoadingProvider);
    final errorMessage = ref.watch(recaptchaErrorProvider);
    final localizations = AppLocalizations.of(context);

    // Listen to verification state changes
    ref.listen<RecaptchaState>(recaptchaNotifierProvider, (previous, next) {
      debugPrint(
          'reCAPTCHA Widget [${PlatformRecaptchaService.platformName}]: State changed from ${previous?.runtimeType} to ${next.runtimeType}');
      final newIsVerified = next is RecaptchaVerified;
      _handleVerificationChanged(ref, newIsVerified);
    });

    // Don't render anything if reCAPTCHA is not required or available
    if (!isRequired) {
      debugPrint('reCAPTCHA Widget: Hidden because not required');
      return const SizedBox.shrink();
    }

    if (recaptchaState is RecaptchaNotAvailable) {
      debugPrint(
          'reCAPTCHA Widget: Hidden because state is RecaptchaNotAvailable: ${recaptchaState.reason}');
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: errorMessage != null
              ? context.error
              : isVerified
                  ? context.primary
                  : context.outline.withAlpha(128),
        ),
        borderRadius: BorderRadius.circular(8),
        color: isVerified
            ? context.primary.withAlpha(26)
            : context.surfaceContainer,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Platform-aware checkbox with enhanced visual feedback
              GestureDetector(
                onTap: enabled
                    ? () => isVerified ? _handleReset(ref) : _handleVerify(ref)
                    : null,
                child: Container(
                  width: 24, // Slightly larger for better mobile interaction
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isVerified ? context.primary : context.outline,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: isVerified
                        ? context.primary
                        : enabled
                            ? context.surfaceContainerHighest
                            : context.surfaceContainer,
                  ),
                  child: isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(3),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(enabled
                                ? context.primary
                                : context.onSurface.withAlpha(128)),
                          ),
                        )
                      : isVerified
                          ? Icon(
                              Icons.check,
                              size: 16,
                              color: context.onPrimary,
                            )
                          : null,
                ),
              ),

              const SizedBox(width: 12),

              // Enhanced text with platform indication
              Expanded(
                child: GestureDetector(
                  onTap: enabled
                      ? () =>
                          isVerified ? _handleReset(ref) : _handleVerify(ref)
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.bodyMedium(
                        localizations?.translate('recaptcha_checkbox') ??
                            "I'm not a robot",
                        color: enabled
                            ? context.onSurface
                            : context.onSurface.withAlpha(102),
                        fontWeight: FontWeight.w500,
                      ),
                      // Platform indicator for debugging (only in debug mode)
                      // if (kDebugMode) ...[
                      //   const SizedBox(height: 2),
                      //   CommonText.bodySmall(
                      //     'Platform: ${PlatformRecaptchaService.platformName} | Action: $action',
                      //     color: context.onSurfaceVariant.withAlpha(128),
                      //     fontSize: 10,
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ),

              // Enhanced reCAPTCHA branding with platform awareness
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: context.surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: context.outline.withAlpha(64),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PlatformRecaptchaService.isWebPlatform
                              ? Icons.language
                              : Icons.smartphone,
                          size: 12,
                          color: context.primary,
                        ),
                        const SizedBox(width: 4),
                        CommonText.bodySmall(
                          'reCAPTCHA',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: context.onSurfaceVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _launchUrl('https://policies.google.com/privacy'),
                          child: CommonText.bodySmall(
                            localizations?.translate('privacy') ?? 'Privacy',
                            fontSize: 8,
                            color: context.primary,
                          ),
                        ),
                        CommonText.bodySmall(
                          ' - ',
                          fontSize: 8,
                          color: context.onSurfaceVariant,
                        ),
                        GestureDetector(
                          onTap: () =>
                              _launchUrl('https://policies.google.com/terms'),
                          child: CommonText.bodySmall(
                            localizations?.translate('terms') ?? 'Terms',
                            fontSize: 8,
                            color: context.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Error message with better styling
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.error.withAlpha(26),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: context.error.withAlpha(64),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 16,
                    color: context.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CommonText.bodySmall(
                      errorMessage,
                      color: context.error,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Loading state with platform information
          if (recaptchaState is RecaptchaInitializing) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(context.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CommonText.bodySmall(
                      localizations?.translate('recaptcha_initializing') ??
                          'Initializing reCAPTCHA for ${PlatformRecaptchaService.platformName}...',
                      color: context.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _launchUrl(String url) {
    debugPrint('Launch URL: $url');
    // TODO: Implement URL launching logic if needed
  }
}

/// Factory methods for common reCAPTCHA widget use cases
extension RecaptchaWidgetFactory on RecaptchaWidget {
  /// Create reCAPTCHA widget for login action
  static Widget forLogin({bool enabled = true}) {
    return RecaptchaWidget(
      enabled: enabled,
      action: 'login',
    );
  }

  /// Create reCAPTCHA widget for signup action
  static Widget forSignup({bool enabled = true}) {
    return RecaptchaWidget(
      enabled: enabled,
      action: 'signup',
    );
  }

  /// Create reCAPTCHA widget for password reset action
  static Widget forPasswordReset({bool enabled = true}) {
    return RecaptchaWidget(
      enabled: enabled,
      action: 'password_reset',
    );
  }

  /// Create reCAPTCHA widget for forgot password action
  static Widget forForgotPassword({bool enabled = true}) {
    return RecaptchaWidget(
      enabled: enabled,
      action: 'forgot_password',
    );
  }
}
