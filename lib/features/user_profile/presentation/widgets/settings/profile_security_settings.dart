import 'package:cointiply_app/core/core.dart';
import 'package:flutter/material.dart';

class ProfileSecuritySettings extends StatefulWidget {
  const ProfileSecuritySettings({super.key});

  @override
  State<ProfileSecuritySettings> createState() =>
      _ProfileSecuritySettingsState();
}

class _ProfileSecuritySettingsState extends State<ProfileSecuritySettings> {
  bool enable2FA = false;
  bool enableSecurityPin = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ─────────────────────────────
          CommonText.titleLarge(
            localizations?.translate('security_settings_title') ??
                'Sign in / Security Settings',
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 24),

          // ─── Email Address ────────────────────────
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

          const Divider(thickness: 0.5),
          const SizedBox(height: 8),

          // ─── 2FA Pin Code ─────────────────────────
          _buildSwitchRow(
            context,
            title: localizations?.translate('security_enable_2fa') ??
                'Enable 2FA Pin Codes',
            subtitle: localizations?.translate('security_enable_2fa_desc') ??
                'A code will be sent to your email every time you log in with a new device.',
            value: enable2FA,
            onChanged: (v) => setState(() => enable2FA = v),
          ),

          const Divider(thickness: 0.5),
          const SizedBox(height: 8),

          // ─── 4 Digit Pin ──────────────────────────
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withAlpha(40),
              border: Border.all(color: colorScheme.error, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: colorScheme.onError,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.bodyLarge(
                        localizations?.translate('security_2fa_app') ??
                            '2FA Authenticator App',
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 4),
                      CommonText.bodySmall(
                        localizations?.translate('security_2fa_app_desc') ??
                            'Two-factor authentication apps add an extra layer of security to your account. When you log in on a new device, you will have to enter a time-sensitive 6-digit code.',
                        color: colorScheme.onErrorContainer,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: CommonText.bodyMedium(
                    localizations?.translate('security_enable') ?? 'Enable',
                    color: colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

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
            activeColor: colorScheme.primary,
            inactiveTrackColor: colorScheme.surfaceContainerHigh,
          ),
        ],
      ),
    );
  }
}
