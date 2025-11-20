part of '../manage_profile_dialog.dart';

class SettingTabContentWidget extends StatelessWidget {
  const SettingTabContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 32.0,
      children: [
        _settingMenuItem(context,
            title: "Language", btnTitle: "Change Language", onPressed: () {}),
        _settingMenuItem(context,
            title: "Notifications",
            btnTitle: "Change Language",
            isSwitch: true,
            description:
                "Enable notifications to receive alerts about important matters",
            onPressed: () {}),
        _settingMenuItem(context,
            title: "Show Your Stats",
            btnTitle: "Manage Privacy",
            isSwitch: true,
            isSelected: true,
            description:
                "When enabled, your account stats are shown on your profile.Enabled by default.",
            onPressed: () {}),
        _settingMenuItem(context,
            title: "Anonymous in contests",
            btnTitle: "Manage Privacy",
            isSwitch: true,
            description:
                """When enabled, your account appears anonymously in contest
rankings. Off by default.""",
            onPressed: () {}),
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
                        thumbColor: !isSelected ? null : WidgetStatePropertyAll(context.primary.withAlpha(150)),
                        inactiveTrackColor: Color(0xff4D4D4D),
                        activeTrackColor:
                            context.colorScheme.primary,
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
