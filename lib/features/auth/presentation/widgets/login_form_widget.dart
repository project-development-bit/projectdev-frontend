import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/config/app_constant.dart';
import '../../../../core/widgets/recaptcha_widget.dart';
import '../../../../core/providers/consolidated_auth_provider.dart';
import '../providers/login_provider.dart';

/// Reusable login form widget that can be used in both login page and popup
class LoginFormWidget extends ConsumerStatefulWidget {
  const LoginFormWidget({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.onSignUp,
    this.showSignUpLink = true,
    this.showRememberMe = true,
  });

  /// Callback when login is successful
  final VoidCallback? onLoginSuccess;

  /// Callback when forgot password is tapped
  final VoidCallback? onForgotPassword;

  /// Callback when sign up is tapped
  final VoidCallback? onSignUp;

  /// Whether to show sign up link
  final bool showSignUpLink;

  /// Whether to show remember me checkbox
  final bool showRememberMe;

  @override
  ConsumerState<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends ConsumerState<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();

    // Listen to login state changes
    ref.listenManual<LoginState>(loginNotifierProvider, (previous, next) async {
      if (!mounted) return;

      switch (next) {
        case LoginSuccess():
          // Call success callback if provided
          widget.onLoginSuccess?.call();

          // Show success message
          if (mounted) {
            final localizations = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations?.translate('login_successful') ??
                    'Login successful!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          break;
        case LoginError():
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: Colors.red,
            ),
          );
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // Check if login can be attempted (includes reCAPTCHA check)
      final canAttemptLogin = ref.read(canAttemptLoginProvider);

      if (!canAttemptLogin) {
        final localizations = AppLocalizations.of(context);
        context.showErrorSnackBar(
          message: localizations?.translate('recaptcha_required') ??
              'Please verify that you are not a robot',
        );
        return;
      }

      // Use consolidated auth actions for login
      final authActions = ref.read(authActionsProvider);

      // Reset previous states
      authActions.resetAllStates();

      await authActions.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  void _handleForgotPassword() {
    widget.onForgotPassword?.call();
  }

  void _handleSignUp() {
    widget.onSignUp?.call();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isLoading = ref.watch(isAnyAuthLoadingProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email Field
          CommonTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            hintText:
                localizations?.translate('email_hint') ?? 'Enter your email',
            labelText: localizations?.translate('email') ?? 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) => TextFieldValidators.email(value, context),
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),

          const SizedBox(height: 16),

          // Password Field
          CommonTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            hintText: localizations?.translate('password_hint') ??
                'Enter your password',
            labelText: localizations?.translate('password') ?? 'Password',
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outlined),
            validator: (value) => TextFieldValidators.minLength(
                value, 6, context,
                fieldName: localizations?.translate('password') ?? 'Password'),
            onSubmitted: (_) => _handleLogin(),
          ),

          const SizedBox(height: 16),

          // Remember Me & Forgot Password Row
          if (widget.showRememberMe || widget.onForgotPassword != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.showRememberMe)
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      CommonText.bodyMedium(
                        localizations?.translate('remember_me') ??
                            'Remember me',
                        color: context.onSurfaceVariant,
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                if (widget.onForgotPassword != null)
                  TextButton(
                    onPressed: _handleForgotPassword,
                    child: CommonText.bodyMedium(
                      localizations?.translate('forgot_password') ??
                          'Forgot Password?',
                      color: context.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),

          const SizedBox(height: 24),

          // reCAPTCHA Widget (managed by Riverpod)
          RecaptchaWidget(
            enabled: !isLoading,
          ),

          const SizedBox(height: 24),

          // Login Button
          CommonButton(
            text: localizations?.translate('sign_in') ?? 'Sign In',
            onPressed: isLoading ? null : _handleLogin,
            backgroundColor: context.primary,
            textColor: context.onPrimary,
            height: 56,
            borderRadius: 12,
            isLoading: isLoading,
            fontSize: context.titleMedium?.fontSize,
          ),

          // Social Login Section
          if (isReadyScocial) ...[
            const SizedBox(height: 24),

            // Divider with OR
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: context.outline.withAlpha(15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CommonText.bodySmall(
                    localizations?.translate('or') ?? 'OR',
                    color: context.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: context.outline.withAlpha(15),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Social Login Buttons
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: localizations?.translate('google') ?? 'Google',
                    onPressed: () {
                      // TODO: Implement Google login
                      context.showErrorSnackBar(
                        message: localizations
                                ?.translate('google_login_coming_soon') ??
                            'Google login coming soon!',
                      );
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    isOutlined: true,
                    backgroundColor: Colors.transparent,
                    textColor: context.onSurface,
                    height: 48,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CommonButton(
                    text: localizations?.translate('facebook') ?? 'Facebook',
                    onPressed: () {
                      // TODO: Implement Facebook login
                      context.showErrorSnackBar(
                        message: localizations
                                ?.translate('facebook_login_coming_soon') ??
                            'Facebook login coming soon!',
                      );
                    },
                    icon: const Icon(Icons.facebook, size: 24),
                    isOutlined: true,
                    backgroundColor: Colors.transparent,
                    textColor: context.onSurface,
                    height: 48,
                  ),
                ),
              ],
            ),
          ],

          // Sign Up Link
          if (widget.showSignUpLink && widget.onSignUp != null) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText.bodyMedium(
                  localizations?.translate('no_account') ??
                      "Don't have an account? ",
                  color: context.onSurfaceVariant,
                ),
                TextButton(
                  onPressed: _handleSignUp,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: CommonText.bodyMedium(
                    localizations?.translate('sign_up') ?? 'Sign Up',
                    color: context.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
