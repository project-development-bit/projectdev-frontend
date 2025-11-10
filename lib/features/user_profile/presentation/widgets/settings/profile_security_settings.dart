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
    final localizations = AppLocalizations.of(context);

    // Status Display based on state
    return switch (check2FAState) {
      Check2FAStatusLoading() => _build2FALoading(context, localizations),
      Check2FAStatusSuccess(:final is2FAEnabled) =>
        _build2FAStatus(context, localizations, is2FAEnabled),
      Check2FAStatusError(:final message) =>
        _build2FAError(context, localizations, message),
      _ => _build2FAInitial(context, localizations),
    };
  }

  // Loading State
  Widget _build2FALoading(
      BuildContext context, AppLocalizations? localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border.all(color: context.outline, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(6),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(context.onPrimary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonText.bodyMedium(
              localizations?.translate('2fa_checking_status') ??
                  'Checking 2FA status...',
              color: context.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // Enabled/Disabled Status
  Widget _build2FAStatus(BuildContext context, AppLocalizations? localizations,
      bool is2FAEnabled) {
    final statusColor = is2FAEnabled ? AppColors.success : AppColors.error;
    final buttonColor = is2FAEnabled
        ? AppColors.error
        : AppColors.success; // Always red for both states

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(color: statusColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              is2FAEnabled ? Icons.verified_rounded : Icons.security,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodyLarge(
                  is2FAEnabled
                      ? (localizations?.translate('2fa_enabled_title') ??
                          '2FA Authenticator Enabled')
                      : (localizations?.translate('2fa_disabled_title') ??
                          '2FA Authenticator Disabled'),
                  color: context.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                CommonText.bodySmall(
                  is2FAEnabled
                      ? (localizations?.translate('2fa_enabled_desc') ??
                          'Your account is protected with two-factor authentication. You will need to enter a 6-digit code when logging in from new devices.')
                      : (localizations?.translate('2fa_disabled_desc') ??
                          'Enable two-factor authentication to add an extra layer of security to your account. You will need to enter a time-sensitive 6-digit code when logging in.'),
                  color: context.onSurface.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
            child: CommonText.bodyMedium(
              is2FAEnabled
                  ? (localizations?.translate('2fa_disable') ?? 'Disable')
                  : (localizations?.translate('2fa_enable') ?? 'Enable'),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Error State
  Widget _build2FAError(
      BuildContext context, AppLocalizations? localizations, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.error, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(
              Icons.error_outline,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodyLarge(
                  localizations?.translate('2fa_error_title') ??
                      'Failed to Load 2FA Status',
                  color: context.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                CommonText.bodySmall(
                  message,
                  color: context.onSurface.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ref.read(check2FAStatusProvider.notifier).check2FAStatus();
            },
            child: CommonText.bodyMedium(
              localizations?.translate('btn_retry') ?? 'Retry',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Initial State
  Widget _build2FAInitial(
      BuildContext context, AppLocalizations? localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: 0.1),
        border: Border.all(color: context.primary, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: context.onPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText.bodyLarge(
                  localizations?.translate('2fa_initial_title') ??
                      '2FA Authenticator App',
                  color: context.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 4),
                CommonText.bodySmall(
                  localizations?.translate('2fa_initial_desc') ??
                      'Check your two-factor authentication status to see if your account is protected with an extra layer of security.',
                  color: context.onSurface.withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ref.read(check2FAStatusProvider.notifier).check2FAStatus();
            },
            child: CommonText.bodyMedium(
              localizations?.translate('2fa_check_status') ?? 'Check Status',
              color: context.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
