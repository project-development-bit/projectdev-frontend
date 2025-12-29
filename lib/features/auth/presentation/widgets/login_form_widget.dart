import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/login_form/html_login_view.dart';

import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/widgets/cloudflare_turnstille_widgte.dart';
import 'package:gigafaucet/core/providers/turnstile_provider.dart';
import 'package:gigafaucet/features/auth/presentation/providers/login_provider.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/or_divider_widget.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/remember_me_widget.dart';
import 'package:gigafaucet/features/auth/presentation/providers/ip_country_provider.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/socials/social_login_butttons.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/common/common_text.dart';
import '../../../localization/data/helpers/app_localizations.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/providers/consolidated_auth_provider.dart';
import '../../../../core/services/secure_storage_service.dart';

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

  bool _isInialized = false;

  bool _rememberMe = false;
  bool get _hasEmailError => _isInialized
      ? TextFieldValidators.email(_emailController.text, context) != null
      : _emailController.text.isNotEmpty &&
          TextFieldValidators.email(_emailController.text, context) != null;
  bool get _hasPasswordError => _isInialized
      ? TextFieldValidators.email(_passwordController.text, context) != null
      : _passwordController.text.isNotEmpty &&
          TextFieldValidators.password(_passwordController.text, context) !=
              null;

  @override
  void initState() {
    super.initState();

    // Load saved credentials after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCredentials();
      ref.read(getIpCountryNotifierProvider.notifier).detectCountry();
      _emailController.addListener(_handleAutoFillBehavior);
      _passwordController.addListener(_handleAutoFillBehavior);
    });
  }

  @override
  void dispose() {
    disposeHtmlLoginRegistry();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  /// Load saved credentials if remember me was enabled
  Future<void> _loadSavedCredentials() async {
    try {
      debugPrint('🔍 Loading saved credentials...');
      final secureStorage = ref.read(secureStorageServiceProvider);
      final rememberMeEnabled = await secureStorage.isRememberMeEnabled();

      debugPrint('🔍 Remember me enabled: $rememberMeEnabled');

      if (rememberMeEnabled) {
        final savedEmail = await secureStorage.getSavedEmail();
        final savedPassword = await secureStorage.getSavedPassword();

        debugPrint('🔍 Saved email: $savedEmail');
        debugPrint('🔍 Saved password exists: ${savedPassword != null}');

        if (savedEmail != null && savedPassword != null && mounted) {
          // Set text directly on controllers (they handle their own notifications)
          _emailController.text = savedEmail;
          _passwordController.text = savedPassword;

          // Update remember me state
          setState(() {
            _rememberMe = true;
          });

          debugPrint('✅ Saved credentials loaded for: $savedEmail');
          debugPrint('✅ Email controller text: ${_emailController.text}');
          debugPrint(
              '✅ Password controller text length: ${_passwordController.text.length}');
          if (kIsWeb) {
            restoreDataToHtml();
          }
        } else {
          debugPrint('⚠️ No saved credentials found or widget not mounted');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load saved credentials: $e');
    }
  }

  /// Save credentials when remember me is checked and login is successful
  Future<void> _saveCredentialsIfNeeded() async {
    try {
      debugPrint('🔍 Saving credentials... Remember me: $_rememberMe');
      final secureStorage = ref.read(secureStorageServiceProvider);
      await secureStorage.saveRememberMeCredentials(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        rememberMe: _rememberMe,
      );
      debugPrint('✅ Credentials save operation completed');
    } catch (e) {
      debugPrint('⚠️ Failed to save remember me credentials: $e');
    }
  }

  void _handleLoginFromHtml(String email, String password) {
    if (!mounted) {
      debugPrint('⚠️ Login callback ignored — widget unmounted');
      return;
    }

    String? emailError;
    String? passwordError;

    // Ensure controllers are synced before validation
    _emailController.text = email;
    _passwordController.text = password;

    emailError = TextFieldValidators.email(email, context);
    passwordError = TextFieldValidators.password(password, context);

    //  Update error state getters
    setState(() {});

    // ❌ Invalid → send errors to HTML
    if (emailError != null || passwordError != null) {
      sendErrorsToHtml(
        emailError: emailError,
        passwordError: passwordError,
      );
      return;
    }

    // ✅ Valid → clear errors
    clearErrorsInHtml();

    _handleLogin(email: email, password: password);
  }

  void _handleLogin({String? email, String? password}) async {
    final loginNotifier = ref.read(loginNotifierProvider);
    if (loginNotifier is LoginLoading) {
      debugPrint(
          ' Web login requested ⏳ Login already in progress, ignoring duplicate request');
      return;
    }

    if (email == null && password == null) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    // Check Turnstile verification
    final turnstileCanAttempt =
        ref.read(turnstileNotifierProvider(TurnstileActionEnum.login))
            is TurnstileSuccess;

    if (!turnstileCanAttempt) {
      final localizations = AppLocalizations.of(context);

      context.showErrorSnackBar(
        message: localizations?.translate('turnstile_required') ??
            'Please complete the security verification',
      );
      return;
    }

    // Get the Turnstile token
    final turnstileToken = turnstileCanAttempt
        ? (ref.read(turnstileNotifierProvider(TurnstileActionEnum.login))
                as TurnstileSuccess)
            .token
        : null;

    if (turnstileToken == null) {
      final localizations = AppLocalizations.of(context);
      context.showErrorSnackBar(
        message: localizations?.translate('turnstile_token_missing') ??
            'Security verification token is missing. Please try again.',
      );
      return;
    }

    // Use consolidated auth actions for login
    final authActions = ref.read(authActionsProvider);

    // Reset previous states
    authActions.resetAllStates();
    final ipState = ref.read(getIpCountryNotifierProvider);

    await authActions.login(
        email: email ?? _emailController.text.trim(),
        password: password ?? _passwordController.text.trim(),
        countryCode: ipState.country?.code ?? "Unknown",
        onSuccess: () async {
          await _saveCredentialsIfNeeded();

          widget.onLoginSuccess?.call();
          // if (mounted) {
          //   final localizations = AppLocalizations.of(context);
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(
          //       content: Text(localizations?.translate('login_successful') ??
          //           'Login successful!'),
          //       backgroundColor: AppColors.success,
          //     ),
          //   );
          // }
        },
        onError: (v) {
          context.showSnackBar(
              message: v, backgroundColor: Theme.of(context).colorScheme.error);
        });
  }

  void _handleAutoFillBehavior() {
    final email = _emailController.text.trim();
    final validEmail = _isValidEmail(email);
    final passwordFilled = _passwordController.text.isNotEmpty;

    if (validEmail && !passwordFilled && !_passwordFocusNode.hasFocus) {
      _passwordFocusNode.requestFocus();
    }
    if (validEmail && passwordFilled) {
      setState(() {});
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{3,}$');
    return regex.hasMatch(email.trim());
  }

  double get _htmlLoginHeight {
    if (_hasEmailError && _hasPasswordError) {
      return context.isMobile ? 145 : 150;
    }
    if (_hasEmailError || _hasPasswordError) {
      return 125;
    }
    return 100;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (_isInialized == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isInialized = true;
      });
    }

    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText.headlineLarge(
              context.translate('sign_in'),
              fontWeight: FontWeight.w700,
              color: context.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (kIsWeb)
              SizedBox(
                width: 600,
                height: _htmlLoginHeight,
                child: buildHtmlLoginView(
                  onLogin: _handleLoginFromHtml,
                ),
              ),

            // --- MOBILE NATIVE FIELDS ---
            if (!kIsWeb) ...[
              CommonTextField(
                fillColor: const Color(0xFF1A1A1A),
                key: const ValueKey('emailField'),
                controller: _emailController,
                focusNode: _emailFocusNode,
                hintText: localizations?.translate('email_hint') ??
                    'Enter your email',
                labelText: localizations?.translate('email') ?? 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (value) => TextFieldValidators.email(value, context),
                onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                autofillHints: const [
                  AutofillHints.email,
                  AutofillHints.username
                ],
              ),
              const SizedBox(height: 16),
              CommonTextField(
                fillColor: const Color(0xFF1A1A1A),
                key: const ValueKey('passwordField'),
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                hintText: localizations?.translate('password_hint') ??
                    'Enter your password',
                labelText: localizations?.translate('password') ?? 'Password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.lock_outlined),
                validator: (value) =>
                    TextFieldValidators.password(value, context),
                onSubmitted: (_) => _handleLogin(),
                enableSuggestions: false,
                autofillHints: const [AutofillHints.password],
              ),
            ],
            const SizedBox(height: 24),

            // Remember Me & Forgot Password Row
            if (widget.showRememberMe || widget.onForgotPassword != null)
              _buildRememberForgotRow(context),

            const SizedBox(height: 24),

            // Cloudflare Turnstile Security Widget
            const CloudflareTurnstileWidget(
              debugMode: false,
              action: TurnstileActionEnum.login,
            ),

            const SizedBox(height: 24),

            CustomUnderLineButtonWidget(
              title: localizations?.translate('sign_in') ?? 'Sign In',
              onTap: kIsWeb
                  ? () => requestLoginDataFromHtml()
                  : () => _handleLogin(),
              height: 56,
              borderRadius: 12,
              fontSize: 14,
            ),
            const OrDividerWidget(),
            SocialLoginButtons(onLoginSuccess: widget.onLoginSuccess),

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
                    onPressed: widget.onSignUp,
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
      ),
    );
  }

  Widget _buildRememberForgotRow(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final rememberMeWidget = widget.showRememberMe
        ? RememberMeWidget(
            value: _rememberMe,
            label: localizations?.translate('remember_me') ?? "Remember me",
            onChanged: (checked) async {
              setState(() => _rememberMe = checked);

              if (!checked) {
                final secureStorage = ref.read(secureStorageServiceProvider);
                await secureStorage.clearRememberMeCredentials();
              }
            },
          )
        : const SizedBox.shrink();

    final forgotPasswordWidget = widget.onForgotPassword != null
        ? TextButton(
            onPressed: widget.onForgotPassword,
            child: CommonText.bodyMedium(
              localizations?.translate('forgot_password') ?? 'Forgot Password?',
              overflow: TextOverflow.ellipsis,
              color: context.primary,
              fontWeight: FontWeight.w500,
            ),
          )
        : const SizedBox.shrink();

    return context.screenWidth < 400
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rememberMeWidget,
              const SizedBox(height: 8),
              forgotPasswordWidget,
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rememberMeWidget,
              forgotPasswordWidget,
            ],
          );
  }
}
