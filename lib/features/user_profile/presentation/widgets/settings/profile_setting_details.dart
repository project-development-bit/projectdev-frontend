import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:cointiply_app/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingDetails extends ConsumerStatefulWidget {
  const ProfileSettingDetails({super.key});

  @override
  ConsumerState<ProfileSettingDetails> createState() =>
      _ProfileSettingDetailsState();
}

class _ProfileSettingDetailsState extends ConsumerState<ProfileSettingDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameCtrl = TextEditingController();

  bool enableInterest = false;

  @override
  void initState() {
    super.initState();

    // Seed once from whatever is already in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(currentUserProvider); // CurrentUserState
      final user = state.user; // uses the extension above
      _usernameCtrl.text = user?.name ?? '';
    });
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;
    final currentUserState = ref.watch(currentUserProvider);

    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    // Keep in sync if the provider later becomes "loaded"
    ref.listen<CurrentUserState>(currentUserProvider, (prev, next) {
      final user = next.user;
      if (user != null && (_usernameCtrl.text.isEmpty || prev?.user == null)) {
        _usernameCtrl.text = user.name;
      }
    });
    return ResponsiveSection(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Title ─────────────────────────────
                CommonText.titleLarge(
                  localizations?.translate('profile_settings_title') ??
                      'Profile Details',
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 24),

                // ─── Avatar ─────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CommonText.titleLarge(
                            "AU",
                            color: colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      CommonText.bodyMedium(
                        localizations?.translate('profile_avatar') ?? 'Avatar',
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Username ─────────────────────────────
                CommonText.bodyMedium(
                  "${localizations?.translate('profile_username') ?? 'Username'} *",
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),

                CommonTextField(
                  controller: _usernameCtrl,
                  hintText: localizations?.translate('profile_username') ??
                      'Username',
                  labelText: localizations?.translate('profile_username') ??
                      'Username',
                  textInputAction: TextInputAction.done,
                  validator: (value) => TextFieldValidators.minLength(
                    value,
                    4,
                    context,
                    fieldName: localizations?.translate('profile_username') ??
                        'Username',
                  ),
                ),

                const SizedBox(height: 8),

                CommonText.bodySmall(
                  localizations?.translate('profile_username_note') ??
                      'Your username can only be changed once every 30 days.',
                  color: colorScheme.onSurfaceVariant,
                ),

                const SizedBox(height: 24),

                // ─── Enable 5% Interest ───────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CommonText.bodyMedium(
                        localizations?.translate('profile_interest_label') ??
                            'Enable 5% Interest',
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: enableInterest,
                      onChanged: (value) =>
                          setState(() => enableInterest = value),
                      inactiveTrackColor: colorScheme.surfaceContainerHigh,
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                CommonText.bodySmall(
                  localizations?.translate('profile_interest_description') ??
                      'Your account will earn 5% interest when you have more than 35,000 Coins. Interest is paid weekly.',
                  color: colorScheme.onSurfaceVariant,
                ),

                const SizedBox(height: 32),

                // ─── Buttons ─────────────────────────────
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
                      onPressed: () => _usernameCtrl.clear(),
                      child: CommonText.bodyMedium(
                        localizations?.translate('btn_discard') ?? 'Discard',
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
                      onPressed: () async {
                        // print(
                        //     'Save Changes pressed ${!(_formKey.currentState?.validate() ?? false)}');
                        // if (!(_formKey.currentState?.validate() ?? false)) {
                        //   return;
                        // }

                        final currentUser = currentUserState.user;

                        if (currentUser == null) return;

                        profileNotifier.updateProfile(
                          UserUpdateRequest(
                            id: currentUser.id.toString(),
                            name: _usernameCtrl.text.trim(),
                          ),
                        );
                      },
                      child: CommonText.bodyMedium(
                        localizations?.translate('btn_save_changes') ??
                            'Save Changes',
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
