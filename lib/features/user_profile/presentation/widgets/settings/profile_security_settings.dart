import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/auth/presentation/providers/check_2fa_status_provider.dart';
import 'package:cointiply_app/features/auth/presentation/widgets/disable_2fa_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSecuritySettings extends ConsumerStatefulWidget {
  const ProfileSecuritySettings({super.key});

  @override
  ConsumerState<ProfileSecuritySettings> createState() =>
      _ProfileSecuritySettingsState();
}

class _ProfileSecuritySettingsState
    extends ConsumerState<ProfileSecuritySettings> {
  
  bool enableSecurityPin = false;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only initialize user if authenticated
      final isAuthenticated = ref.read(isAuthenticatedObservableProvider);
      if (isAuthenticated) {
        // Check 2FA status
        ref.read(check2FAStatusProvider.notifier).check2FAStatus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.titleLarge(
            localizations?.translate('security_settings_title') ??
                'Sign in / Security Settings',
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 24),

          _buildRowHeader(
            context,
            title:
                localizations?.translate('security_email') ?? 'Email Address',
            trailingButton: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHigh,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: CommonText.bodyMedium(
                localizations?.translate('security_contact_support') ??
                    'Contact Support to Change Email',
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            subtitle: 'aungmyopaing890@gmail.com',
          ),

          // const Divider(thickness: 0.5),
          // const SizedBox(height: 8),

          // _buildSwitchRow(
          //   context,
          //   title: localizations?.translate('security_enable_2fa') ??
          //       'Enable 2FA Pin Codes',
          //   subtitle: localizations?.translate('security_enable_2fa_desc') ??
          //       'A code will be sent to your email every time you log in with a new device.',
          //   value: enable2FA,
          //   onChanged: (v) => setState(() => enable2FA = v),
          // ),

          const Divider(thickness: 0.5),
          const SizedBox(height: 8),

          _buildSwitchRow(
            context,
            title: localizations?.translate('security_enable_pin') ??
                'Enable 4 Digit Security Pin',
            subtitle: localizations?.translate('security_enable_pin_desc') ??
                'You will need to enter a 4 digit pin when confirming important actions.',
            value: enableSecurityPin,
            onChanged: (v) => setState(() => enableSecurityPin = v),
          ),

          const Divider(thickness: 0.5),
          const SizedBox(height: 16),

          // ─── 2FA Authenticator Card ───────────────
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: colorScheme.errorContainer.withAlpha(40),
          //     border: Border.all(color: colorScheme.error, width: 1),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Container(
          //         decoration: BoxDecoration(
          //           color: colorScheme.error,
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         padding: const EdgeInsets.all(6),
          //         child: Icon(
          //           Icons.verified_rounded,
          //           size: 18,
          //           color: colorScheme.onError,
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             CommonText.bodyLarge(
          //               localizations?.translate('security_2fa_app') ??
          //                   '2FA Authenticator App',
          //               color: colorScheme.onErrorContainer,
          //               fontWeight: FontWeight.bold,
          //             ),
          //             const SizedBox(height: 4),
          //             CommonText.bodySmall(
          //               localizations?.translate('security_2fa_app_desc') ??
          //                   'Two-factor authentication apps add an extra layer of security to your account. When you log in on a new device, you will have to enter a time-sensitive 6-digit code.',
          //               color: colorScheme.onErrorContainer,
          //             ),
          //           ],
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: colorScheme.error,
          //           padding: const EdgeInsets.symmetric(
          //             horizontal: 18,
          //             vertical: 12,
          //           ),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //         ),
          //         onPressed: () {},
          //         child: CommonText.bodyMedium(
          //           localizations?.translate('security_enable') ?? 'Enable',
          //           color: colorScheme.onError,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          _build2FASection(context, isMobile: isMobile),

          const SizedBox(height: 32),

          // ─── Footer Buttons ────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.outline),
                  foregroundColor: colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                onPressed: () {},
                child: CommonText.bodyMedium(
                  localizations?.translate("btn_discard") ?? "Discard",
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: CommonText.bodyMedium(
                  localizations?.translate("btn_save_changes") ??
                      "Save Changes",
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRowHeader(
    BuildContext context, {
    required String title,
    String? subtitle,
    Widget? trailingButton,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodyMedium(
                  title,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CommonText.bodyMedium(
                      subtitle,
                      color: colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
          ),
          if (trailingButton != null) trailingButton,
        ],
      ),
    );
  }

  Widget _buildSwitchRow(
    BuildContext context, {
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodyMedium(
                  title,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: CommonText.bodySmall(
                      subtitle,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.surfaceContainerHigh,
          ),
        ],
      ),
    );
  }


  Widget _build2FASection(BuildContext context, {bool isMobile = false}) {
    final check2FAState = ref.watch(check2FAStatusProvider);

    return CommonCard(
      backgroundColor: AppColors.websiteCard,
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.security,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        'Two-Factor Authentication',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      SizedBox(height: 4),
                      CommonText(
                        'Add an extra layer of security to your account',
                        fontSize: 14,
                        color: AppColors.websiteText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status Display
            switch (check2FAState) {
              Check2FAStatusLoading() => _build2FALoading(),
              Check2FAStatusSuccess(:final is2FAEnabled) =>
                _build2FAStatus(context, is2FAEnabled, isMobile: isMobile),
              Check2FAStatusError(:final message) =>
                _build2FAError(context, message),
              _ => _build2FAInitial(context),
            },
          ],
        ),
      ),
    );
  }

  Widget _build2FALoading() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.websiteBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          CommonText(
            'Checking 2FA status...',
            fontSize: 14,
            color: AppColors.websiteText,
          ),
        ],
      ),
    );
  }

  Widget _build2FAStatus(BuildContext context, bool is2FAEnabled,
      {bool isMobile = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: is2FAEnabled
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: is2FAEnabled
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _build2FAStatusInfo(is2FAEnabled),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _build2FAActionButton(context, is2FAEnabled),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: _build2FAStatusInfo(is2FAEnabled)),
                const SizedBox(width: 16),
                _build2FAActionButton(context, is2FAEnabled),
              ],
            ),
    );
  }

  Widget _build2FAStatusInfo(bool is2FAEnabled) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: is2FAEnabled
                ? AppColors.success.withValues(alpha: 0.2)
                : AppColors.warning.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            is2FAEnabled ? Icons.check_circle : Icons.warning_amber,
            color: is2FAEnabled ? AppColors.success : AppColors.warning,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                is2FAEnabled ? '2FA Enabled' : '2FA Disabled',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              CommonText(
                is2FAEnabled
                    ? 'Your account is protected with 2FA'
                    : 'Enable 2FA to secure your account',
                fontSize: 13,
                color: AppColors.websiteText,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _build2FAActionButton(BuildContext context, bool is2FAEnabled) {
    return ElevatedButton.icon(
      onPressed: () {
        if (is2FAEnabled) {
          // Show confirmation dialog to disable 2FA
          context.showDisable2FAConfirmationDialog();
        } else {
          // Show setup dialog to enable 2FA
          context.show2FAVerificationDialog(
            onSuccess: () {
              // Refresh 2FA status after successful enable
              ref.read(check2FAStatusProvider.notifier).check2FAStatus();
            },
          );
        }
      },
      icon: Icon(
        is2FAEnabled ? Icons.block : Icons.shield,
        size: 18,
      ),
      label: CommonText(
        is2FAEnabled ? 'Disable 2FA' : 'Enable 2FA',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: is2FAEnabled ? AppColors.error : AppColors.websiteGold,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _build2FAError(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonText(
                  'Failed to check 2FA status',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                CommonText(
                  message,
                  fontSize: 13,
                  color: AppColors.websiteText,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {
              ref.read(check2FAStatusProvider.notifier).check2FAStatus();
            },
            icon: const Icon(Icons.refresh),
            color: AppColors.error,
            tooltip: 'Retry',
          ),
        ],
      ),
    );
  }

  Widget _build2FAInitial(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.websiteBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: CommonText(
              'Check your 2FA status to see if your account is protected',
              fontSize: 14,
              color: AppColors.websiteText,
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              ref.read(check2FAStatusProvider.notifier).check2FAStatus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const CommonText(
              'Check Status',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
