import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/common_text.dart';
import '../extensions/context_extensions.dart';
import '../providers/recaptcha_provider.dart';
import '../localization/app_localizations.dart';

/// A widget that provides reCAPTCHA verification functionality using Riverpod
class RecaptchaWidget extends ConsumerWidget {
  const RecaptchaWidget({
    super.key,
    this.onVerificationChanged,
    this.enabled = true,
  });

  /// Callback when verification status changes (optional, can use providers instead)
  final ValueChanged<bool>? onVerificationChanged;
  
  /// Whether the widget is enabled
  final bool enabled;

  void _handleVerificationChanged(WidgetRef ref, bool isVerified) {
    // Call callback if provided for backward compatibility
    onVerificationChanged?.call(isVerified);
  }

  void _handleVerify(WidgetRef ref) {
    if (!enabled) return;
    
    final notifier = ref.read(recaptchaNotifierProvider.notifier);
    notifier.verify();
  }

  void _handleReset(WidgetRef ref) {
    final notifier = ref.read(recaptchaNotifierProvider.notifier);
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
      final newIsVerified = next is RecaptchaVerified;
      _handleVerificationChanged(ref, newIsVerified);
    });

    // Don't render anything if reCAPTCHA is not required or available
    if (!isRequired || recaptchaState is RecaptchaNotAvailable) {
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
                  : context.outline.withAlpha(77), // 0.3 opacity
        ),
        borderRadius: BorderRadius.circular(8),
        color: isVerified
            ? context.primary.withAlpha(26) // 0.1 opacity
            : context.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: () => isVerified 
                    ? _handleReset(ref) 
                    : _handleVerify(ref),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isVerified ? context.primary : context.outline,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    color: isVerified ? context.primary : Colors.transparent,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(context.primary),
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
              
              // Text
              Expanded(
                child: GestureDetector(
                  onTap: () => isVerified 
                      ? _handleReset(ref) 
                      : _handleVerify(ref),
                  child: CommonText.bodyMedium(
                    localizations?.translate('recaptcha_checkbox') ?? "I'm not a robot",
                    color: enabled
                        ? context.onSurface
                        : context.onSurface.withAlpha(102), // 0.4 opacity
                  ),
                ),
              ),
              
              // reCAPTCHA logo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText.bodySmall(
                      'reCAPTCHA',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: context.onSurfaceVariant,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonText.bodySmall(
                          localizations?.translate('privacy') ?? 'Privacy',
                          fontSize: 8,
                          color: context.primary,
                        ),
                        CommonText.bodySmall(
                          ' - ',
                          fontSize: 8,
                          color: context.onSurfaceVariant,
                        ),
                        CommonText.bodySmall(
                          localizations?.translate('terms') ?? 'Terms',
                          fontSize: 8,
                          color: context.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Error message
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            CommonText.bodySmall(
              errorMessage,
              color: context.error,
            ),
          ],
          
          // State information for debugging (only in debug mode)
          if (recaptchaState is RecaptchaInitializing) ...[
            const SizedBox(height: 8),
            CommonText.bodySmall(
              localizations?.translate('recaptcha_initializing') ?? 'Initializing reCAPTCHA...',
              color: context.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}