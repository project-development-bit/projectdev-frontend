import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../../../../core/extensions/context_extensions.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations?.translate('field_required', args: [localizations.translate('confirm_password')]) ?? 'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return localizations?.translate('passwords_do_not_match') ?? 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.translate('agree_to_terms_error') ?? 'Please agree to the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement sign up logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        // Navigate to main page on successful sign up
        context.goToHome();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.translate('account_created_successfully') ?? 'Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.translate('sign_up_failed', args: [error.toString()]) ?? 'Sign up failed: $error'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.goToLogin(),
        ),
        actions: [
          const CompactLocaleSwitcher(),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Create Account Text
                Text(
                  localizations?.translate('create_account') ?? 'Create Account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  localizations?.translate('create_account_subtitle') ?? 'Fill in the details below to create your account',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Full Name Field
                CommonTextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  hintText: localizations?.translate('full_name_hint') ?? 'Enter your full name',
                  labelText: localizations?.translate('full_name') ?? 'Full Name',
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: (value) => TextFieldValidators.required(value, context, fieldName: localizations?.translate('full_name') ?? 'Full Name'),
                  onSubmitted: (_) => _emailFocusNode.requestFocus(),
                ),
                
                const SizedBox(height: 20),
                
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
                  onSubmitted: (_) => _phoneFocusNode.requestFocus(),
                ),
                
                const SizedBox(height: 20),
                
                // Phone Field
                CommonTextField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  hintText: localizations?.translate('phone_number_hint') ?? 'Enter your phone number',
                  labelText: localizations?.translate('phone_number') ?? 'Phone Number',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  inputFormatters: TextFieldFormatters.phoneNumber(),
                  validator: (value) => TextFieldValidators.phoneNumber(value, context),
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
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) => TextFieldValidators.password(value, context),
                  onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
                ),
                
                const SizedBox(height: 20),
                
                // Confirm Password Field
                CommonTextField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  hintText: localizations?.translate('confirm_password_hint') ?? 'Confirm your password',
                  labelText: localizations?.translate('confirm_password') ?? 'Confirm Password',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: _validateConfirmPassword,
                  onSubmitted: (_) => _handleSignUp(),
                ),
                
                const SizedBox(height: 24),
                
                // Terms and Conditions
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(text: localizations?.translate('agree_to_terms') ?? 'I agree to the '),
                            TextSpan(
                              text: localizations?.translate('terms_and_conditions') ?? 'Terms and Conditions',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: localizations?.translate('and') ?? ' and '),
                            TextSpan(
                              text: localizations?.translate('privacy_policy') ?? 'Privacy Policy',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Sign Up Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
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
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            localizations?.translate('sign_up') ?? 'Sign Up',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Already have account link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations?.translate('already_have_account') ?? 'Already have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.goToLogin(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        localizations?.translate('sign_in') ?? 'Sign In',
                        style: TextStyle(
                          color: colorScheme.primary,
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
      ),
    );
  }
}