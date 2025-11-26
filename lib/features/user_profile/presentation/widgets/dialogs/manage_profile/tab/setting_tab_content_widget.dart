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

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 32.0,
      children: [
        _settingMenuItem(context,
            title: "Language", btnTitle: "Change Language", onPressed: () {
          showChangeLanguageDialog(context);
        }),
        _settingMenuItem(context,
            title: "Notifications",
            btnTitle: "",
            isSwitch: true,
            isSelected: settingsData.notificationsEnabled,
            description:
                "Enable notifications to receive alerts about important matters",
            onPressed: () {}, onChanged: (v) {
          ref.read(settingProfileProvider.notifier).toggleNotifications(
                userId: userId,
              );
        }),
        _settingMenuItem(context,
            title: "Show Your Stats",
            btnTitle: "Manage Privacy",
            isSwitch: true,
            isSelected: settingsData.showStatsEnabled,
            description:
                "When enabled, your account stats are shown on your profile.Enabled by default.",
            onPressed: () {}, onChanged: (v) {
          ref.read(settingProfileProvider.notifier).toggleShowStats(
                userId: userId,
              );
        }),
        _settingMenuItem(context,
            title: "Anonymous in contests",
            btnTitle: "Manage Privacy",
            isSwitch: true,
            isSelected: settingsData.anonymousInContests,
            description:
                """When enabled, your account appears anonymously in contest
rankings. Off by default.""",
            onPressed: () {}, onChanged: (v) {
          ref.read(settingProfileProvider.notifier).toggleAnonymousInContests(
                userId: userId,
              );
        }),
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
      String? description}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CommonText.titleMedium(title,
                  fontWeight: FontWeight.w700, color: Colors.white),
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
                    : ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(233, 44),
                          backgroundColor: Color(0xFF262626),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: CommonText.titleMedium(btnTitle,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff98989A)),
                      ),
              ),
            )
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
