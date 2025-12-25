import 'package:gigafaucet/core/common/common_dropdown_field_with_icon.dart';
import 'package:gigafaucet/core/common/common_text.dart';
import 'package:gigafaucet/core/common/custom_buttom_widget.dart';
import 'package:gigafaucet/core/theme/app_colors.dart';
import 'package:gigafaucet/features/auth/presentation/providers/ip_country_state.dart';
import 'package:gigafaucet/features/auth/presentation/providers/login_provider.dart';
import 'package:gigafaucet/features/auth/presentation/providers/selected_country_provider.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/onboarding_background.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/or_divider_widget.dart';
import 'package:gigafaucet/features/auth/presentation/widgets/social_signup_butttons.dart';
import 'package:gigafaucet/features/terms_privacy/presentation/services/terms_privacy_navigation_service.dart';
import 'package:gigafaucet/features/auth/presentation/providers/ip_country_provider.dart';
import 'package:gigafaucet/features/user_profile/domain/entities/country.dart';
import 'package:gigafaucet/features/user_profile/presentation/providers/get_countries_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/common_textfield.dart';
import '../../../localization/data/helpers/app_localizations.dart';
import '../../../../core/widgets/cloudflare_turnstille_widgte.dart';
import '../../../../core/providers/turnstile_provider.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/enum/user_role.dart';
import '../providers/register_provider.dart';
import '../../../../routing/app_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final String? referralCode;
  const SignUpPage({super.key, this.referralCode});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _agreeToTerms = false;

  bool isTermsHover = false;
  bool isPrivacyHover = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getCountriesNotifierProvider.notifier).fetchCountries();
    });

    ref.listenManual<GetCountriesState>(getCountriesNotifierProvider,
        (previous, next) {
      if (mounted) {
        if (next.status == GetCountriesStatus.success &&
            ref.read(selectedCountryProvider) == null) {
          ref.read(getIpCountryNotifierProvider.notifier).detectCountry();
        }
      }
    });
    ref.listenManual<IpCountryState>(getIpCountryNotifierProvider,
        (prev, next) {
      final countriesState = ref.read(getCountriesNotifierProvider);
      if (next.country != null && countriesState.countries != null) {
        final detected = countriesState.countries!.firstWhere(
          (c) => c.code.toLowerCase() == next.country!.code?.toLowerCase(),
          orElse: () => Country(code: "", name: "", flag: "", id: 0),
        );
        // Set detected country if not already selected by user or already detected
        if (detected.code.isNotEmpty &&
            mounted &&
            ref.read(selectedCountryProvider) == null) {
          ref.read(selectedCountryProvider.notifier).state = detected;
        }
      }
    });

    // Watch register state for navigation and error handling
    ref.listenManual<RegisterState>(registerNotifierProvider, (previous, next) {
      if (!mounted) return;

      switch (next) {
        case RegisterSuccess():
          // Navigate to verification page on successful registration
          context.goToVerification(
            email: next.email,
            isSendCode: false,
            isFromForgotPassword: false,
          );
          context.showSnackBar(
              message:
                  'Registration successful! Please check your email for the verification code.',
              backgroundColor: AppColors.success);
          break;
        case RegisterError():
          // Show error message
          context.showSnackBar(
              message: next.message,
              backgroundColor: Theme.of(context).colorScheme.error);
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    final localizations = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return localizations?.translate('field_required',
              args: [localizations.translate('confirm_password')]) ??
          'Confirm Password is required';
    }
    if (value != _passwordController.text) {
      return localizations?.translate('passwords_do_not_match') ??
          'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      // Focus on the first field with an error
      if (_nameController.text.isEmpty) {
        _nameFocusNode.requestFocus();
      } else if (_emailController.text.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(_emailController.text)) {
        _emailFocusNode.requestFocus();
      } else if (_passwordController.text.isEmpty ||
          _passwordController.text.length < 8) {
        _passwordFocusNode.requestFocus();
      } else if (_confirmPasswordController.text.isEmpty ||
          _confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordFocusNode.requestFocus();
      }
      return;
    }

    if (!_agreeToTerms) {
      final localizations = AppLocalizations.of(context);
      context.showSnackBar(
        message: localizations?.translate('agree_to_terms_error') ??
            'Please agree to the terms and conditions',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    // Check if Turnstile verification is completed
    final turnstileState =
        ref.read(turnstileNotifierProvider(TurnstileActionEnum.register));
    if (turnstileState is! TurnstileSuccess) {
      final localizations = AppLocalizations.of(context);
      context.showErrorSnackBar(
        message: localizations?.translate('security_verification_required') ??
            'Please complete the security verification',
      );
      return;
    }

    // Use the new register state notifier
    final registerNotifier = ref.read(registerNotifierProvider.notifier);

    await registerNotifier.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      countryCode: ref.read(selectedCountryProvider)?.code ?? '',
      confirmPassword: _confirmPasswordController.text,
      role: UserRole.normalUser, // Default to normal user
      referralCode: widget.referralCode,
      onSuccess: () {
        debugPrint('✅ SignUpPage: Registration successful callback triggered');
      },
      onError: (errorMessage) {
        debugPrint('❌ SignUpPage: Registration error callback: $errorMessage');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading =
        ref.watch(isRegisterLoadingProvider) || loginState is LoginLoading;
    final countriesState = ref.watch(getCountriesNotifierProvider);

    return OnboardingBackground(
      childPadding: EdgeInsets.symmetric(
          vertical: context.isMobile ? 35 : 38.5,
          horizontal: context.isMobile ? 17 : 43),
      girlHeight: 400,
      girlRightOffset: -140,
      girlBottomOffset: -180,
      isLoading: isLoading,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CommonText.headlineLarge(
              localizations?.translate('create_account') ?? 'Create Achhhcount',
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CommonText.bodyMedium(
              localizations?.translate('create_account_subtitle') ??
                  'Fill in the details below to create your account',
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Full Name Field
            CommonTextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              hintText: localizations?.translate('full_name_hint') ??
                  'Enter your full name',
              labelText: localizations?.translate('full_name') ?? 'Full Name',
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(Icons.person_outlined),
              validator: (value) => TextFieldValidators.required(value, context,
                  fieldName:
                      localizations?.translate('full_name') ?? 'Full Name'),
              onSubmitted: (_) => _emailFocusNode.requestFocus(),
            ),

            const SizedBox(height: 16),

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

            SearchableDropdownWithIcon<Country>(
              items: (filter, infiniteScrollProps) => countriesState.countries!,
              selectedItem: ref.watch(selectedCountryProvider),
              onChanged: (country) {
                ref.read(selectedCountryProvider.notifier).state = country;
              },
              // labelText:
              //     localizations?.translate('country_required') ?? 'Country *',
              hintText: localizations?.translate('country_hint') ??
                  'Select Your Country',
              placeholder: Icon(
                Icons.flag,
                color: context.primary,
              ),
              getItemCode: (country) => country.code,
              getItemName: (country) => country.name,
              getItemIconUrl: (country) => country.flag,
              validator: (value) {
                if (value == null) {
                  return context.translate("please_select_country_error");
                }
                return null;
              },
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
              textInputAction: TextInputAction.next,
              prefixIcon: const Icon(Icons.lock_outlined),
              validator: (value) =>
                  TextFieldValidators.password(value, context),
              onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
            ),

            const SizedBox(height: 16),

            // Confirm Password Field
            CommonTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              hintText: localizations?.translate('confirm_password_hint') ??
                  'Confirm your password',
              labelText: localizations?.translate('confirm_password') ??
                  'Confirm Password',
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
                        TextSpan(
                          text: localizations?.translate('agree_to_terms') ??
                              'I agree to the ',
                        ),

                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() => isTermsHover = true),
                            onExit: (_) => setState(() => isTermsHover = false),
                            child: GestureDetector(
                              onTap: () => context.showTerms(),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isTermsHover
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CommonText.bodyMedium(
                                  localizations
                                          ?.translate('terms_and_conditions') ??
                                      'Terms and Conditions',
                                  color: isTermsHover
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.8)
                                      : colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),

                        TextSpan(
                          text: localizations?.translate('and') ?? ' and ',
                        ),

                        // ---------------- PRIVACY (with hover background) ----------------
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) =>
                                setState(() => isPrivacyHover = true),
                            onExit: (_) =>
                                setState(() => isPrivacyHover = false),
                            child: GestureDetector(
                              onTap: () => context.showPrivacy(),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isPrivacyHover
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: CommonText.bodyMedium(
                                  localizations?.translate('privacy_policy') ??
                                      'Privacy Policy',
                                  color: isPrivacyHover
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.8)
                                      : colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 24),

            // Cloudflare Turnstile Widget (replaces reCAPTCHA)
            CloudflareTurnstileWidget(
              action: TurnstileActionEnum.register,
              debugMode: false,
            ),

            const SizedBox(height: 32),

            // Referral Bonus Message
            if (widget.referralCode != null &&
                widget.referralCode!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText.titleSmall(
                            localizations?.translate('referral_bonus') ??
                                'Referral Bonus',
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          CommonText.bodySmall(
                            localizations
                                    ?.translate('referral_bonus_message') ??
                                'Sign up with this referral code and receive coins worth \$500!',
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],

            // Sign Up Button
            CustomUnderLineButtonWidget(
              title: localizations?.translate('sign_up') ?? 'Sign Up',
              onTap: _handleSignUp,
              height: 56,
              borderRadius: 12,
              fontSize: 14,
            ),
            OrDividerWidget(),
            SocialSignupButtons(
              referralCode: widget.referralCode,
              agreeToTerms: _agreeToTerms,
            ),

            const SizedBox(height: 32),

            // Already have account link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText.bodyMedium(
                  localizations?.translate('already_have_account') ??
                      'Already have an account? ',
                  color: colorScheme.onSurfaceVariant,
                ),
                TextButton(
                  onPressed: () => context.goToLogin(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: CommonText.bodyMedium(
                    localizations?.translate('sign_in') ?? 'Sign In',
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
