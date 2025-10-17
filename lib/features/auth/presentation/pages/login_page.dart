import 'package:cointiply_app/core/error/error_model.dart';
import 'package:cointiply_app/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/common/common_button.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/translation_provider.dart';
import '../../../../core/providers/auth_debug_provider.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../../../../core/widgets/theme_switch_widget.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../routing/app_router.dart';
import '../providers/login_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual<LoginState>(loginNotifierProvider, (previous, next) async {
      if (!mounted) return;

      // Debug logging
      final debugNotifier = ref.read(authDebugProvider.notifier);
      debugNotifier
          .logAuthState('LoginPage: state changed to ${next.runtimeType}');

      switch (next) {
        case LoginSuccess():
          // Add a small delay to ensure all async operations complete
          Future.delayed(const Duration(milliseconds: 100), () async {
            if (mounted) {
              final localizations = AppLocalizations.of(context);
              // Log auth state before navigation
              debugNotifier
                  .logAuthState('LoginPage: before navigation to home');

              // Navigate to home on successful login

              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations?.translate('login_successful') ??
                      'Login successful!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
            
            if (mounted) {

              // Use GoRouter.of(context).go() to replace the current route
              GoRouter.of(context).go(AppRoutes.home);
            }
          });
          break;
        case LoginError():
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: Colors.red,
            ),
          );
          _checkVerifyCode(next.errorModel);
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
      final loginNotifier = ref.read(loginNotifierProvider.notifier);

      // Reset any previous state before attempting new login
      loginNotifier.reset();

      await loginNotifier.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  void _handleForgotPassword() {
    // Navigate to forgot password page
    context.goToForgotPassword();
  }

  void _handleSignUp() {
    // Navigate to sign up page
    context.goToSignUp();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isLoading = ref.watch(isLoginLoadingProvider);

    // Watch login state for navigation and error handling

    // Also watch the locale provider to force rebuilds when locale changes
    final currentLocale = ref.watch(localeProvider);
    final translate = ref.watch(translationProvider);

    debugPrint('LoginPage building with locale: ${currentLocale.languageCode}');
    debugPrint(
        'Testing direct translation for "welcome_back": ${translate('welcome_back')}');

    return Scaffold(
      backgroundColor: context
          .surface, // Using extension instead of theme.colorScheme.surface
      body: SafeArea(
        child: Stack(
          children: [
            // Main login content
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    // App Logo/Icon
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: context.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.fastfood_rounded,
                          size: 64,
                          color: context.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Welcome Text - Testing direct translation provider
                    CommonText.headlineMedium(
                      translate('welcome_back'),
                      fontWeight: FontWeight.bold,
                      color: context.onSurface,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    CommonText.bodyLarge(
                      translate('sign_in_subtitle'),
                      color: context.onSurfaceVariant,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    // Email Field
                    CommonTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      hintText: localizations?.translate('email_hint') ??
                          'Enter your email',
                      labelText: localizations?.translate('email') ?? 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) =>
                          TextFieldValidators.email(value, context),
                      onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                    ),

                    const SizedBox(height: 20),

                    // Password Field
                    CommonTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      hintText: localizations?.translate('password_hint') ??
                          'Enter your password',
                      labelText:
                          localizations?.translate('password') ?? 'Password',
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      validator: (value) => TextFieldValidators.minLength(
                          value, 6, context,
                          fieldName: localizations?.translate('password') ??
                              'Password'),
                      onSubmitted: (_) => _handleLogin(),
                    ),

                    const SizedBox(height: 16),

                    // Remember Me & Forgot Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        ),
                        TextButton(
                          onPressed: _handleForgotPassword,
                          child: CommonText.bodyMedium(
                            localizations?.translate('forgot_password') ??
                                'Forgot Password?',
                            color: context.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

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
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement Google login
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(localizations?.translate(
                                          'google_login_coming_soon') ??
                                      'Google login coming soon!'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.g_mobiledata, size: 24),
                            label: Text(
                                localizations?.translate('google') ?? 'Google'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: context.outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement Facebook login
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(localizations?.translate(
                                          'facebook_login_coming_soon') ??
                                      'Facebook login coming soon!'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.facebook, size: 24),
                            label: Text(localizations?.translate('facebook') ??
                                'Facebook'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: context.outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Sign Up Link
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

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Locale and theme switch widgets positioned at top-right
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ThemeSwitchWidget(),
                  const SizedBox(width: 8),
                  const LocaleSwitchWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _checkVerifyCode(ErrorModel? errorModel) {
    /// If the error model indicates that email verification is required,
    /// show verification dialog
    if (errorModel?.isUnverifiedAccount == true) {
      _showVerificationDialog();
    }
  }

  void _showVerificationDialog() {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap verify or cancel
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: context.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText.titleLarge(
                  localizations?.translate('verify_email') ??
                      'Verify Your Email',
                  fontWeight: FontWeight.bold,
                  color: context.onSurface,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.bodyLarge(
                localizations?.translate('verification_required_title') ??
                    'Account Verification Required',
                fontWeight: FontWeight.w600,
                color: context.onSurface,
              ),
              const SizedBox(height: 12),
              CommonText.bodyMedium(
                localizations?.translate('verification_required_message') ??
                    'Your account needs to be verified before you can log in. We\'ll send a verification code to your email address.',
                color: context.onSurface.withAlpha(179), // 0.7 opacity
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primary.withAlpha(26), // 0.1 opacity
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CommonText.bodySmall(
                        _emailController.text.trim(),
                        fontWeight: FontWeight.w600,
                        color: context.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            CommonButton(
              text: localizations?.translate('cancel') ?? 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              isOutlined: true,
              textColor: context.onSurface.withAlpha(153), // 0.6 opacity
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            CommonButton(
              text: localizations?.translate('verify_now') ?? 'Verify Now',
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to verification page with email
                GoRouter.of(context).push(
                    '/auth/verification?email=${Uri.encodeComponent(_emailController.text.trim())}',
                    extra: true);
              },
              backgroundColor: context.primary,
              textColor: context.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ],
        );
      },
    );
  }
}
