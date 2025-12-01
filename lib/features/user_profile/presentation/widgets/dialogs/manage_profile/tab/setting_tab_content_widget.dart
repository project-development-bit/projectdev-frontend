part of '../manage_profile_dialog.dart';

class SettingTabContentWidget extends ConsumerStatefulWidget {
  const SettingTabContentWidget({super.key});

  @override
  ConsumerState<SettingTabContentWidget> createState() =>
      _SettingTabContentWidgetState();
}

class _SettingTabContentWidgetState
    extends ConsumerState<SettingTabContentWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsData =
          ref.watch(getProfileNotifierProvider).profile?.settings;
      ref.read(settingProfileProvider.notifier).initSettings(
            notificationsEnabled: settingsData?.notificationsEnabled ?? false,
            showStatsEnabled: settingsData?.showStatsEnabled ?? false,
            anonymousInContests: settingsData?.anonymousInContests ?? false,
            language: settingsData?.language ?? "En",
          );
    });

    ref.listenManual<SettingProfileState>(
      settingProfileProvider,
      (previous, next) {
        if (next.status == SettingProfileStatus.failure) {
          final errorMessage = next.errorMessage ??
              context.translate("failed_to_update_settings");
          context.showSnackBar(
              message: errorMessage, backgroundColor: context.error);
        }
        if (next.status == SettingProfileStatus.success) {
          ref
              .read(getProfileNotifierProvider.notifier)
              .fetchProfile(isLoading: false);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = (ref.watch(profileCurrentUserProvider)?.id ?? 0).toString();
    final settingsData = ref.watch(settingProfileProvider);
    final language = settingsData.language;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 32.0,
      children: [
        _settingMenuItem(context,
            title: context.translate("language"),
            btnTitle: context.translate("change_language"), onPressed: () {
          showChangeLanguageDialog(context);
        }),
        _settingMenuItem(context,
            title: context.translate("notifications"),
            btnTitle: "",
            isSwitch: true,
            isSelected: settingsData.notificationsEnabled,
            description: context.translate("notifications_description"),
            onPressed: () {}, onChanged: (v) {
          ref.read(settingProfileProvider.notifier).toggleNotifications(
                userId: userId,
              );
        }),
        _settingMenuItem(context,
            title: context.translate("show_your_stats"),
            btnTitle: context.translate("manage_privacy"),
            isSwitch: true,
            isSelected: settingsData.showStatsEnabled,
            description: context.translate("show_stats_description"),
            onPressed: () {}, onChanged: (v) {
          ref.read(settingProfileProvider.notifier).toggleShowStats(
                userId: userId,
              );
        }),
        _settingMenuItem(context,
            title: context.translate("anonymous_in_contests"),
            btnTitle: context.translate("manage_privacy"),
            isSwitch: true,
            isSelected: settingsData.anonymousInContests,
            description: context.translate("anonymous_contests_description"),
            onPressed: () {}, onChanged: (v) {
          ref.read(settingProfileProvider.notifier).toggleAnonymousInContests(
                userId: userId,
              );
        }),
        _settingMenuItem(context,
            title: context.translate("delete_account"),
            btnTitle: context.translate("delete_account"), onPressed: () {
          showDeleteAccountConfirmationDialog(context);
        },
            description: context.translate("delete_account_description"),
            isDanger: true),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _settingMenuItem(BuildContext context,
      {required String title,
      required Function() onPressed,
      required String btnTitle,
      bool isSwitch = false,
      bool isSelected = false,
      Function(bool)? onChanged,
      String? description,
      bool isDanger = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CommonText.titleMedium(title,
                  fontWeight: FontWeight.w700,
                  color: isDanger ? context.error : Colors.white),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: isSwitch
                    ? Switch(
                        value: isSelected,
                        onChanged: onChanged,
                        thumbColor: !isSelected
                            ? null
                            : WidgetStatePropertyAll(
                                context.primary.withAlpha(150)),
                        inactiveTrackColor: Color(0xff4D4D4D),
                        activeTrackColor: context.colorScheme.primary,
                      )
                    : CustomUnderLineButtonWidget(
                        title: btnTitle,
                        onTap: onPressed,
                        fontColor: isDanger ? context.error : Color(0xff98989A),
                        isRed: isDanger,
                        isDark: true,
                        backgroundColor: isDanger
                            ? context.error.withValues(alpha: 0.1)
                            : Color(0xFF262626),
                        borderColor: isDanger
                            ? context.error.withValues(alpha: 0.3)
                            : null,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
              ),
            ),
          ],
        ),
        if (description != null)
          Row(
            children: [
              Expanded(child: SizedBox()),
              Expanded(
                flex: 2,
                child: CommonText.bodyMedium(description,
                    color: Color(0xff98989A)),
              )
            ],
          ),
      ],
    );
  }
}
