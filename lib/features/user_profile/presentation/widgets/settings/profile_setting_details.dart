import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/user_profile/data/models/request/user_update_request.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/update_profile_provider.dart';
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
  late String _initialUsernameValue;
  bool enableInterest = false;

  @override
  void initState() {
    super.initState();
    // Seed once from whatever is already in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(currentUserProvider); // CurrentUserState
      final user = state.user; // uses the extension above
      _usernameCtrl.text = user?.name ?? '';
      _initialUsernameValue = _usernameCtrl.text;
    });

    ref.listenManual<UpdateProfileState>(updateProfileProvider,
        (previous, next) {
      switch (next.status) {
        case UpdateProfileStatus.success:
          _handleProfileSuccess();
          break;
        case UpdateProfileStatus.failure:
          _handleProfileError(
              next.errorMessage ?? 'An unknown error occurred.');
          break;
        default:
          break;
      }
    });
  }

  void _handleProfileSuccess() {
    ref.read(currentUserProvider.notifier).refreshUser();
    _initialUsernameValue = _usernameCtrl.text;
    // Handle profile loaded successfully
    final localizations = AppLocalizations.of(context);
    context.showSuccessSnackBar(
      message: localizations?.translate('profile_update_success') ??
          'Profile updated successfully!',
    );
  }

  void _handleProfileError(String error) {
    // Handle profile load error
    context.showErrorSnackBar(
      message: error,
    );
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

    final profileNotifier = ref.read(updateProfileProvider.notifier);
    // Keep in sync if the provider later becomes "loaded"
    ref.listen<CurrentUserState>(currentUserProvider, (prev, next) {
      final user = next.user;
      if (user != null && (_usernameCtrl.text.isEmpty || prev?.user == null)) {
        _usernameCtrl.text = user.name;
        _initialUsernameValue = _usernameCtrl.text;
      }
    });

    final profileState = ref.watch(updateProfileProvider);

    return ResponsiveSection(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(100),
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
                      currentUserState.user?.name.isNotEmpty == true
                          ? Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: colorScheme.onSurface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: CommonText.titleLarge(
                                  currentUserState.user!.name
                                      .substring(0, 1)
                                      .toUpperCase(),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: AppColors.websiteText,
                              child: Icon(Icons.person,
                                  size: 56, color: colorScheme.onError),
                            ),
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
                    CommonButton(
                      fontSize: 12,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      text: localizations?.translate('btn_save_changes') ??
                          'Save Changes',
                      isLoading: profileState.isLoading,
                      onPressed: () {
                        if (_usernameCtrl.text.trim() ==
                            _initialUsernameValue) {
                          context.showErrorSnackBar(
                            message: localizations
                                    ?.translate('no_changes_to_save') ??
                                'No changes to save.',
                          );
                          return;
                        }

                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        final currentUser = currentUserState.user;

                        if (currentUser == null) return;

                        profileNotifier.updateProfile(
                          UserUpdateRequest(
                            id: currentUser.id.toString(),
                            name: _usernameCtrl.text.trim(),
                          ),
                        );
                      },
                      backgroundColor: context.primary,
                      textColor: context.onPrimary,
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
