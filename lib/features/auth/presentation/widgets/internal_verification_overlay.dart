import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:cointiply_app/features/common/widgets/custom_pointer_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/common/common_text.dart';

/// Provider to manage internal verification state
final internalVerificationProvider =
    StateNotifierProvider<InternalVerificationNotifier, bool>((ref) {
  return InternalVerificationNotifier();
});

/// State notifier for internal verification
class InternalVerificationNotifier extends StateNotifier<bool> {
  InternalVerificationNotifier() : super(false);

  /// Check if verification has been completed in this session
  bool get isVerified => state;

  /// Mark verification as completed
  void markVerified() {
    state = true;
  }

  /// Reset verification (for testing purposes)
  void reset() {
    state = false;
  }
}

/// Configuration for internal verification
class InternalVerificationConfig {
  /// Set to false to bypass verification entirely (for development)
  static const bool isEnabled = true;

  /// The verification code required
  static const String requiredCode = "2026";

  /// Whether to show debug information
  static const bool showDebugInfo = true;
}

/// Internal verification popup overlay
class InternalVerificationOverlay extends ConsumerStatefulWidget {
  final Widget child;

  const InternalVerificationOverlay({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<InternalVerificationOverlay> createState() =>
      _InternalVerificationOverlayState();
}

class _InternalVerificationOverlayState
    extends ConsumerState<InternalVerificationOverlay> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isLoading = false;
  String? _errorMessage;

  static const String _correctCode = InternalVerificationConfig.requiredCode;

  @override
  void initState() {
    super.initState();
    // Auto-focus the input field when popup opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _handleVerification() {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = "Please enter the verification code";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (code == _correctCode) {
          // Correct code entered
          ref.read(internalVerificationProvider.notifier).markVerified();

          // Show success message
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('✅ Internal verification successful'),
          //     backgroundColor: AppColors.success,
          //     duration: Duration(seconds: 2),
          //   ),
          // );
        } else {
          // Incorrect code
          setState(() {
            _errorMessage = "Incorrect verification code. Please try again.";
            _isLoading = false;
          });
          _codeController.clear();
          _codeFocusNode.requestFocus();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If verification is disabled in config, just show the app
    if (!InternalVerificationConfig.isEnabled) {
      return widget.child;
    }

    final isVerified = ref.watch(internalVerificationProvider);

    // If verified, show the normal app
    if (isVerified) {
      return widget.child;
    }

    // Show verification popup
    return Material(
      color: AppColors.lightTextPrimary, // Dark overlay
      child: Stack(
        children: [
          // App content (blurred/disabled)
          Positioned.fill(
            child: AbsorbPointer(
              child: Opacity(
                opacity: 0.1,
                child: widget.child,
              ),
            ),
          ),

          // Verification popup
          Center(
            child: CustomPointerInterceptor(
              child: Container(
                margin: EdgeInsets.all(context.isMobile ? 20 : 32),
                constraints: BoxConstraints(
                  maxWidth: context.isMobile ? double.infinity : 400,
                  maxHeight: context.isMobile ? double.infinity : 600,
                ),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius:
                      BorderRadius.circular(context.isMobile ? 16 : 20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightTextPrimary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(context.isMobile ? 20 : 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: context.primary.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.security,
                          size: 40,
                          color: context.primary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      CommonText.headlineMedium(
                        'Internal Access Verification',
                        fontWeight: FontWeight.bold,
                        color: context.onSurface,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      CommonText.bodyMedium(
                        'Enter the internal verification code to access the application',
                        color: context.onSurfaceVariant,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // Code input field
                      TextFormField(
                        controller: _codeController,
                        focusNode: _codeFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Verification Code',
                          hintText: 'Enter code',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorText: _errorMessage,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                        onFieldSubmitted: (_) => _handleVerification(),
                      ),

                      const SizedBox(height: 24),

                      // Verify button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleVerification,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primary,
                            foregroundColor: context.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.onPrimary,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Verify Access',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info text
                      CommonText.bodySmall(
                        'This is an internal verification for development access',
                        color: context.onSurfaceVariant.withValues(alpha: 0.7),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
