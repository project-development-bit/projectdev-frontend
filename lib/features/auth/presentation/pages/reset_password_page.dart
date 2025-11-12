import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../providers/reset_password_provider.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Listen to reset password state changes
    ref.listenManual<ResetPasswordState>(resetPasswordProvider,
        (previous, next) {
      switch (next) {
        case ResetPasswordSuccess():
          _handleResetSuccess();
          break;
        case ResetPasswordError(message: final message):
          _handleResetError(message);
          break;
        default:
          break;
      }
    });
    // Listen to reset password state changes will be done in build method
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleResetSuccess() {
    final l10n = AppLocalizations.of(context);

    debugPrint('Reset Password Success: Showing success message');

    // Show success message first
    context.showSuccessSnackBar(
      message: l10n?.translate('password_reset_successful') ??
          'Password reset successfully! Please login with your new password.',
    );

    debugPrint('Reset Password Success: SnackBar shown, scheduling navigation');

    // Navigate to login page after allowing snackbar to display
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        debugPrint('Reset Password Success: Navigating to login page');
        context.go('/auth/login');
      } else {
        debugPrint(
            'Reset Password Success: Widget not mounted, skipping navigation');
      }
    });
  }

  void _handleResetError(String message) {
    context.showErrorSnackBar(message: message);
  }

  void _onResetPasswordPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      // Dismiss keyboard
      FocusScope.of(context).unfocus();

      ref.read(resetPasswordProvider.notifier).resetPassword(
            email: widget.email,
            password: _passwordController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
          );
    }
  }

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.translate('please_enter_password') ??
          'Please enter a password';
    }
    if (value.length < 8) {
      return l10n?.translate('password_min_8_chars') ??
          'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n?.translate('please_confirm_password') ??
          'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return l10n?.translate('passwords_must_match') ??
          'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(isResetPasswordLoadingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: CommonText.titleLarge(
          l10n?.translate('reset_password') ?? 'Reset Password',
          color: colorScheme.onError,
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: LocaleToggleButton(),
          ),
        ],
      ),
      body: ResponsiveContainer(
        maxWidth: context.isMobile ? null : 400,
        padding: EdgeInsets.all(context.isMobile ? 20 : 32),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                _buildHeader(context, l10n),

                SizedBox(height: context.isMobile ? 32 : 40),

                // Password Input Fields
                _buildPasswordFields(context, l10n),

                SizedBox(height: context.isMobile ? 32 : 40),

                // Reset Password Button
                _buildResetButton(context, l10n, isLoading),

                SizedBox(height: context.isMobile ? 24 : 32),

                // Back to Login Link
                _buildBackToLoginLink(context, l10n),

                // Extra space at bottom for better scrolling
                SizedBox(height: context.isMobile ? 20 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations? l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo or Icon
        Container(
          width: context.isMobile ? 80 : 100,
          height: context.isMobile ? 80 : 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(context.isMobile ? 40 : 50),
          ),
          child: Icon(
            Icons.lock_reset,
            size: context.isMobile ? 40 : 50,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        SizedBox(height: context.isMobile ? 16 : 24),

        CommonText.headlineSmall(
          l10n?.translate('create_new_password') ?? 'Create New Password',
          textAlign: TextAlign.center,
          color: Theme.of(context).colorScheme.onSurface,
        ),

        const SizedBox(height: 8),

        CommonText.bodyMedium(
          '${l10n?.translate('for_email') ?? 'For'}: ${widget.email}',
          textAlign: TextAlign.center,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),

        const SizedBox(height: 8),

        CommonText.bodySmall(
          l10n?.translate('password_requirements') ??
              'Password must be at least 8 characters long',
          textAlign: TextAlign.center,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildPasswordFields(BuildContext context, AppLocalizations? l10n) {
    return Column(
      children: [
        // New Password Field
        CommonTextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          labelText: l10n?.translate('new_password') ?? 'New Password',
          hintText: l10n?.translate('enter_new_password') ??
              'Enter your new password',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.next,
          validator: _validatePassword,
          onSubmitted: (_) {
            _confirmPasswordFocusNode.requestFocus();
          },
        ),

        SizedBox(height: context.isMobile ? 16 : 20),

        // Confirm Password Field
        CommonTextField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          labelText:
              l10n?.translate('confirm_new_password') ?? 'Confirm Password',
          hintText: l10n?.translate('confirm_new_password') ??
              'Confirm your new password',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          obscureText: !_isConfirmPasswordVisible,
          textInputAction: TextInputAction.done,
          validator: _validateConfirmPassword,
          onSubmitted: (_) {
            final isLoading = ref.read(isResetPasswordLoadingProvider);
            if (!isLoading) {
              _onResetPasswordPressed();
            }
          },
        ),
      ],
    );
  }

  Widget _buildResetButton(
      BuildContext context, AppLocalizations? l10n, bool isLoading) {
    return CommonButton(
      text: l10n?.translate('reset_password') ?? 'Reset Password',
      onPressed: isLoading ? null : _onResetPasswordPressed,
      isLoading: isLoading,
      height: context.isMobile ? 50 : 56,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildBackToLoginLink(BuildContext context, AppLocalizations? l10n) {
    return Center(
      child: TextButton(
        onPressed: () {
          context.go('/auth/login');
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: CommonText.bodyMedium(
                l10n?.translate('back_to_login') ?? 'Back to Login',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
