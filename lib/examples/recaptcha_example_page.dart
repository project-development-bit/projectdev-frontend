import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/recaptcha_provider.dart';
import '../core/providers/consolidated_auth_provider.dart';
import '../core/widgets/recaptcha_widget.dart';
import '../core/common/common_button.dart';
import '../core/common/common_text.dart';
import '../core/extensions/context_extensions.dart';

/// Example page demonstrating how to use the new Riverpod-based reCAPTCHA system
class RecaptchaExamplePage extends ConsumerWidget {
  const RecaptchaExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch various reCAPTCHA states using providers
    final recaptchaState = ref.watch(recaptchaNotifierProvider);
    final isRequired = ref.watch(isRecaptchaRequiredProvider);
    final isVerified = ref.watch(isRecaptchaVerifiedProvider);
    final isLoading = ref.watch(isRecaptchaLoadingProvider);
    final errorMessage = ref.watch(recaptchaErrorProvider);
    final token = ref.watch(recaptchaTokenProvider);
    
    // Watch consolidated auth state
    final consolidatedState = ref.watch(consolidatedAuthStateProvider);
    final canAttemptLogin = ref.watch(canAttemptLoginProvider);
    
    // Get auth actions
    final authActions = ref.read(authActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('reCAPTCHA Example'),
        backgroundColor: context.primary,
        foregroundColor: context.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            CommonText.headlineMedium(
              'Riverpod reCAPTCHA Example',
              color: context.onSurface,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // reCAPTCHA Widget
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.titleMedium(
                      'reCAPTCHA Widget',
                      color: context.onSurface,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const RecaptchaWidget(
                      enabled: true,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // State Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.titleMedium(
                      'reCAPTCHA State Information',
                      color: context.onSurface,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildStateItem(context, 'Current State', recaptchaState.runtimeType.toString()),
                    _buildStateItem(context, 'Required', isRequired.toString()),
                    _buildStateItem(context, 'Verified', isVerified.toString()),
                    _buildStateItem(context, 'Loading', isLoading.toString()),
                    _buildStateItem(context, 'Error', errorMessage ?? 'None'),
                    _buildStateItem(context, 'Token', token != null ? '${token.substring(0, 20)}...' : 'None'),
                    _buildStateItem(context, 'Can Attempt Login', canAttemptLogin.toString()),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.titleMedium(
                      'Actions',
                      color: context.onSurface,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            text: 'Verify reCAPTCHA',
                            onPressed: isLoading ? null : () async {
                              await authActions.verifyRecaptcha();
                            },
                            backgroundColor: context.primary,
                            textColor: context.onPrimary,
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        Expanded(
                          child: CommonButton(
                            text: 'Reset reCAPTCHA',
                            onPressed: () {
                              authActions.resetRecaptcha();
                            },
                            isOutlined: true,
                            backgroundColor: Colors.transparent,
                            textColor: context.primary,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CommonButton(
                      text: 'Simulate Login',
                      onPressed: canAttemptLogin ? () async {
                        // Show success/error based on login attempt
                        if (isVerified || !isRequired) {
                          context.showSuccessSnackBar(
                            message: 'Login would succeed! reCAPTCHA verified or not required.',
                          );
                        } else {
                          context.showErrorSnackBar(
                            message: 'Login blocked: reCAPTCHA verification required.',
                          );
                        }
                      } : null,
                      backgroundColor: context.secondary,
                      textColor: context.onSecondary,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Consolidated State Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.titleMedium(
                      'Consolidated Auth State',
                      color: context.onSurface,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildStateItem(context, 'Is Loading', consolidatedState.isLoading.toString()),
                    _buildStateItem(context, 'Is Auth Ready', consolidatedState.isAuthReady.toString()),
                    _buildStateItem(context, 'Can Attempt Login', consolidatedState.canAttemptLogin.toString()),
                    _buildStateItem(context, 'Current Error', consolidatedState.currentError ?? 'None'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Usage Instructions
            Card(
              color: context.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.titleMedium(
                      'How to Use Riverpod reCAPTCHA',
                      color: context.onSurface,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    CommonText.bodyMedium(
                      '1. Add RecaptchaWidget to your forms\n'
                      '2. Watch isRecaptchaVerifiedProvider for verification status\n'
                      '3. Use canAttemptLoginProvider to check if actions can proceed\n'
                      '4. Use authActions.verifyRecaptcha() to trigger verification\n'
                      '5. Use consolidatedAuthStateProvider for comprehensive state',
                      color: context.onSurface,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: CommonText.bodyMedium(
              '$label:',
              fontWeight: FontWeight.w600,
              color: context.onSurface,
            ),
          ),
          Expanded(
            child: CommonText.bodyMedium(
              value,
              color: context.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}