import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/locale_switch_widget.dart';
import '../providers/verification_provider.dart';
import '../widgets/verification_code_input.dart';

class VerificationPage extends ConsumerStatefulWidget {
  final String email;
  
  const VerificationPage({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends ConsumerState<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Check if all fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final code = _controllers.map((controller) => controller.text).join();
      _verifyCode(code);
    }
  }

  void _verifyCode(String code) {
    ref.read(verificationNotifierProvider.notifier).verifyCode(
      email: widget.email,
      code: code,
    );
  }

  void _resendCode() {
    ref.read(verificationNotifierProvider.notifier).resendCode(
      email: widget.email,
    );
  }

  void _clearCode() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final verificationState = ref.watch(verificationNotifierProvider);

    // Listen to state changes for navigation
    ref.listen<VerificationState>(verificationNotifierProvider, (previous, next) {
      if (next is VerificationSuccess) {
        // Show success message and navigate to login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/auth/login');
      } else if (next is VerificationError) {
        // Show error message and clear code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
        _clearCode();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () => context.go('/auth/signup'),
        ),
        actions: const [
          LocaleSwitchWidget(),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              
              // Header Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: context.primary.withAlpha(26), // 0.1 * 255 = 26
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 40,
                    color: context.primary,
                  ),
                ),              const SizedBox(height: 24),
              
              // Title
              CommonText.headlineMedium(
                localizations?.translate('verify_email') ?? 'Verify Your Email',
                fontWeight: FontWeight.bold,
                color: context.onSurface,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Description
              CommonText.bodyLarge(
                localizations?.translate('verification_description') ?? 
                'We have sent a 4-digit verification code to',
                color: context.onSurface.withAlpha(179), // 0.7 * 255 = 179
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Email display
              CommonText.bodyLarge(
                widget.email,
                fontWeight: FontWeight.w600,
                color: context.primary,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Verification Code Input
              VerificationCodeInput(
                controllers: _controllers,
                focusNodes: _focusNodes,
                onChanged: _onCodeChanged,
                enabled: verificationState is! VerificationLoading,
              ),
              
              const SizedBox(height: 24),
              
              // Loading indicator or error state
              if (verificationState is VerificationLoading)
                const CircularProgressIndicator()
              else if (verificationState is VerificationError)
                Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    CommonText.bodyMedium(
                      'Please try again',
                      color: Colors.red,
                    ),
                  ],
                ),
              
              const Spacer(),
              
              // Resend code section
              Column(
                children: [
                  CommonText.bodyMedium(
                    localizations?.translate('didnt_receive_code') ?? 
                    "Didn't receive the code?",
                    color: context.onSurface.withAlpha(179), // 0.7 * 255 = 179
                  ),
                  
                  const SizedBox(height: 8),
                  
                  TextButton(
                    onPressed: verificationState is VerificationLoading 
                        ? null 
                        : _resendCode,
                    child: CommonText.bodyMedium(
                      localizations?.translate('resend_code') ?? 'Resend Code',
                      color: context.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}