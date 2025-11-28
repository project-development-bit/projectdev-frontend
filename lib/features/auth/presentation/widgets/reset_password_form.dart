import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/common_textfield.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/auth/presentation/providers/reset_password_provider.dart';
import 'package:cointiply_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordForm extends ConsumerStatefulWidget {
  const ResetPasswordForm({super.key, required this.email});
  final String email;

  @override
  ConsumerState<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends ConsumerState<ResetPasswordForm> {
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
    debugPrint('Reset Password Success: Showing success message');

    // Show success message first
    context.showSuccessSnackBar(
      message: context.translate('password_reset_successful'),
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
    if (value == null || value.isEmpty) {
      return context.translate('please_enter_password');
    }
    if (value.length < 8) {
      return context.translate('password_min_8_chars');
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return context.translate('please_confirm_password');
    }
    if (value != _passwordController.text) {
      return context.translate('passwords_must_match');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isResetPasswordLoadingProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          _buildHeader(
            context,
          ),

          SizedBox(height: 40),

          // Password Input Fields
          _buildPasswordFields(
            context,
          ),

          SizedBox(height: 24),

          // Reset Password Button
          _buildResetButton(context, isLoading),

          SizedBox(height: 32),

          // Back to Login Link
          _buildBackToLoginLink(
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.headlineLarge(
          context.translate('create_new_password'),
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(height: 16),
        CommonText.bodyMedium(
          '${context.translate('for_email')}: ${widget.email}',
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        CommonText.bodyMedium(
          context.translate('password_requirements'),
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildPasswordFields(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: Column(
        children: [
          // New Password Field
          CommonTextField(
            fillColor: Color(0xFF1A1A1A), //TODO Use from theme
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            labelText: context.translate('new_password'),
            hintText: context.translate('enter_new_password'),
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
            fillColor: Color(0xFF1A1A1A), //TODO Use from theme
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            labelText: context.translate('confirm_new_password'),
            hintText: context.translate('confirm_new_password'),
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
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: CustomUnderLineButtonWidget(
        title: context.translate('reset_password'),
        isLoading: isLoading,
        onTap: isLoading ? () {} : _onResetPasswordPressed,
        height: context.isMobile ? 50 : 56,
        isActive: true,
      ),
    );
  }

  Widget _buildBackToLoginLink(
    BuildContext context,
  ) {
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
              size: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: CommonText.bodyMedium(
                context.translate('back_to_login'),
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
