import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import 'login_form_widget.dart';

/// Popup overlay that shows login form when user is not authenticated
class LoginPopupOverlay extends ConsumerWidget {
  const LoginPopupOverlay({
    super.key,
    required this.child,
    required this.showPopup,
    this.onLoginSuccess,
  });

  /// The main app content to show behind the overlay
  final Widget child;

  /// Whether to show the login popup
  final bool showPopup;

  /// Callback when login is successful
  final VoidCallback? onLoginSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!showPopup) {
      return child;
    }

    return Stack(
      children: [
        // Main app content (with reduced interaction)
        AbsorbPointer(
          absorbing: showPopup,
          child: child,
        ),

        // Login popup overlay
        _LoginPopupModal(
          onLoginSuccess: onLoginSuccess,
        ),
      ],
    );
  }
}

/// The actual modal dialog for login
class _LoginPopupModal extends ConsumerWidget {
  const _LoginPopupModal({
    this.onLoginSuccess,
  });

  final VoidCallback? onLoginSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    return Material(
      color: Colors.black.withOpacity(0.7), // Semi-transparent background
      child: Center(
        child: Container(
          margin: EdgeInsets.all(context.isMobile ? 16 : 24),
          constraints: BoxConstraints(
            maxWidth: context.isMobile ? context.screenWidth * 0.9 : 400,
            maxHeight: context.isMobile ? context.screenHeight * 0.8 : 600,
          ),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(context.isMobile ? 16 : 20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // App Logo/Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: 24,
                        color: context.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText.titleLarge(
                            localizations?.translate('welcome_back') ??
                                'Welcome Back',
                            fontWeight: FontWeight.bold,
                            color: context.onSurface,
                          ),
                          CommonText.bodyMedium(
                            localizations?.translate('sign_in_to_continue') ??
                                'Sign in to continue',
                            color: context.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                    // Close button (Note: We don't allow closing as per requirements)
                    // Users must login to proceed
                    Icon(
                      Icons.login,
                      color: context.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),

              // Login form content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: LoginFormWidget(
                    onLoginSuccess: () {
                      // The popup will be automatically dismissed when auth state changes
                      onLoginSuccess?.call();
                    },
                    onForgotPassword: () {
                      // Navigate to forgot password page
                      context.go('/auth/forgot-password');
                    },
                    onSignUp: () {
                      // Navigate to sign up page
                      context.go('/auth/signup');
                    },
                    showSignUpLink: true,
                    showRememberMe: true,
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security,
                      size: 16,
                      color: context.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    CommonText.bodySmall(
                      localizations?.translate('secure_login') ??
                          'Your information is secure',
                      color: context.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
