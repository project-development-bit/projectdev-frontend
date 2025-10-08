import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/translation_provider.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../../../../core/widgets/theme_switch_widget.dart';
import '../../../../core/extensions/context_extensions.dart';

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
  
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement login logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        // Navigate to main page on successful login
        context.goToHome();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.translate('login_successful') ?? 'Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.translate('login_failed', args: [error.toString()]) ?? 'Login failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
    
    // Also watch the locale provider to force rebuilds when locale changes
    final currentLocale = ref.watch(localeProvider);
    final translate = ref.watch(translationProvider);
    
    debugPrint('LoginPage building with locale: ${currentLocale.languageCode}');
    debugPrint('Testing direct translation for "welcome_back": ${translate('welcome_back')}');
    
    return Scaffold(
      backgroundColor: context.surface, // Using extension instead of theme.colorScheme.surface
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
                Text(
                  translate('welcome_back'),
                  style: context.headlineMedium?.copyWith( // Using context extension
                    fontWeight: FontWeight.bold,
                    color: context.onSurface, // Using context extension
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  translate('sign_in_subtitle'),
                  style: context.bodyLarge?.copyWith( // Using context extension
                    color: context.onSurfaceVariant, // Using context extension
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Email Field
                CommonTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  hintText: localizations?.translate('email_hint') ?? 'Enter your email',
                  labelText: localizations?.translate('email') ?? 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) => TextFieldValidators.email(value, context),
                  onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),
                
                const SizedBox(height: 20),
                
                // Password Field
                CommonTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  hintText: localizations?.translate('password_hint') ?? 'Enter your password',
                  labelText: localizations?.translate('password') ?? 'Password',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) => TextFieldValidators.minLength(value, 6, context, fieldName: localizations?.translate('password') ?? 'Password'),
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
                        Text(
                          localizations?.translate('remember_me') ?? 'Remember me',
                          style: context.bodyMedium?.copyWith(
                            color: context.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _handleForgotPassword,
                      child: Text(
                        localizations?.translate('forgot_password') ?? 'Forgot Password?',
                        style: TextStyle(
                          color: context.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Login Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primary,
                      foregroundColor: context.onPrimary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            localizations?.translate('sign_in') ?? 'Sign In',
                            style: context.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.onPrimary,
                            ),
                          ),
                  ),
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
                      child: Text(
                        localizations?.translate('or') ?? 'OR',
                        style: context.bodySmall?.copyWith(
                          color: context.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
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
                              content: Text(localizations?.translate('google_login_coming_soon') ?? 'Google login coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.g_mobiledata, size: 24),
                        label: Text(localizations?.translate('google') ?? 'Google'),
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
                              content: Text(localizations?.translate('facebook_login_coming_soon') ?? 'Facebook login coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.facebook, size: 24),
                        label: Text(localizations?.translate('facebook') ?? 'Facebook'),
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
                    Text(
                      localizations?.translate('no_account') ?? "Don't have an account? ",
                      style: context.bodyMedium?.copyWith(
                        color: context.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: _handleSignUp,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        localizations?.translate('sign_up') ?? 'Sign Up',
                        style: TextStyle(
                          color: context.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
}
