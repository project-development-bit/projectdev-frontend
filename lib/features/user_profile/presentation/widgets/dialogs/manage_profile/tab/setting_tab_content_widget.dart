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
    final languageFlag = Language.empty().getDisplayFlag(language);
    final languageName = Language.empty().getDisplayName(language);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 25.0,
      children: [
        _languageWidget(context, languageFlag, languageName),
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
            title: context.translate("show_your_stats",
                args: [context.isDesktop ? "\n" : " "]),
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
            title: context.translate("anonymous_in_contests",
                args: [context.isDesktop ? "\n" : " "]),
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
            title: context.translate("delete_account",
                args: [context.isDesktop ? "\n" : " "]),
            btnTitle: context.translate("delete_your_account"), onPressed: () {
          showDeleteAccountConfirmationDialog(context);
        },
            description: context.translate("delete_account_description"),
            isDanger: true),
      ],
    );
  }

  Widget _languageWidget(
      BuildContext context, String languageFlag, String language) {
    final isMobile = context.isMobile;

    return isMobile
        ? Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.bodyLarge(context.translate("language"),
                      fontWeight: FontWeight.w700, color: Colors.white),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonImage(
                        imageUrl: languageFlag,
                        width: 32,
                        height: 21,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 5),
                      CommonText.bodyMedium(
                        language,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CustomUnderLineButtonWidget(
                title: context.translate("change_language"),
                onTap: () {
                  showChangeLanguageDialog(context);
                },
                fontColor: Color(0xff98989A),
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 10,
                ),
                width: double.infinity,
                isDark: true,
                backgroundColor: Color(0xFF262626),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ],
          )
        :
     Row(
            children: [
              SizedBox(
                width: 130,
                child: CommonText.bodyLarge(context.translate("language"),
                    fontWeight: FontWeight.w700, color: Colors.white),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonImage(
                          imageUrl: languageFlag,
                          width: 32,
                          height: 21,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        CommonText.bodyMedium(
                          language,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomUnderLineButtonWidget(
                        title: context.translate("change_language"),
                        onTap: () {
                          showChangeLanguageDialog(context);
                        },
                        fontColor: Color(0xff98989A),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),
                        isDark: true,
                        backgroundColor: Color(0xFF262626),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
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
    final isMobile = context.isMobile;
    return isMobile
        ? Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 130,
                    child: CommonText.bodyLarge(title,
                        fontWeight: FontWeight.w700,
                        color: isDanger ? context.error : Colors.white),
                  ),
                  if (isSwitch)
                    Switch(
                      value: isSelected,
                      onChanged: onChanged,
                      thumbColor: !isSelected
                          ? null
                          : WidgetStatePropertyAll(
                              context.primary.withAlpha(150)),
                      inactiveTrackColor: Color(0xff4D4D4D),
                      trackOutlineWidth: WidgetStatePropertyAll(0.0),
                      activeTrackColor: context.colorScheme.primary,
                    )
                ],
              ),
              isSwitch
                  ? SizedBox()
                  : CustomUnderLineButtonWidget(
                      title: btnTitle,
                      onTap: onPressed,
                      fontColor: isDanger ? context.error : Color(0xff98989A),
                      isRed: isDanger,
                      isDark: true,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      backgroundColor: isDanger
                          ? context.error.withValues(alpha: 0.1)
                          : Color(0xFF262626),
                      borderColor: isDanger
                          ? context.error.withValues(alpha: 0.3)
                          : null,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
              if (description != null)
                CommonText.bodyMedium(description, color: Color(0xff98989A)),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: CommonText.bodyLarge(title,
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
                              fontColor:
                                  isDanger ? context.error : Color(0xff98989A),
                              isRed: isDanger,
                              isDark: true,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 10,
                              ),
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
                    SizedBox(width: 130),
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
