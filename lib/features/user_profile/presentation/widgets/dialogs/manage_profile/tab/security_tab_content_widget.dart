part of '../manage_profile_dialog.dart';

class SecurityTabContentWidget extends ConsumerStatefulWidget {
  const SecurityTabContentWidget({super.key});

  @override
  ConsumerState<SecurityTabContentWidget> createState() =>
      _SecurityTabContentWidgetState();
}

class _SecurityTabContentWidgetState
    extends ConsumerState<SecurityTabContentWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final securityData =
        ref.watch(getProfileNotifierProvider).profile?.security;

    final is2FAEnabled = securityData?.twofaEnabled ?? false;
    final isPinEnabled = securityData?.securityPinEnabled ?? false;
    final email = ref.watch(profileCurrentUserProvider)?.email ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 32.0,
      children: [
        _securityMenuItem(
            title: "Change Password",
            btnTitle: "Change Password",
            onPressed: () {}),
        _securityMenuItem(
            title: "2FA Authenticator App",
            onPressed: () {
              if (is2FAEnabled) {
                context.showDisable2FAConfirmationDialog(
                  onDisabled: () {
                    // Refresh profile data after disabling 2FA
                    ref
                        .read(getProfileNotifierProvider.notifier)
                        .fetchProfile();
                  },
                );
              } else {
                show2FADialog(context, email: email, onSuccess: () {
                  // Refresh profile data after enabling 2FA
                  ref.read(getProfileNotifierProvider.notifier).fetchProfile();
                });
              }
            },
            btnTitle: is2FAEnabled ? "Disable 2FA" : "Enable 2FA",
            description:
                """Two-factor authentication apps add an extra layer of 
security to your account. When you log in on a new device,
you’ll have to enter a time-sensitive 6-digit code."""),
        _securityMenuItem(
            title: "Enable 4 Digit Security Pin",
            btnTitle:
                isPinEnabled ? "Disable Security Pin" : "Enable Security Pin",
            onPressed: () {}),
      ],
    );
  }

  Widget _securityMenuItem(
      {required String title,
      required Function() onPressed,
      required String btnTitle,
      bool isDisable = false,
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
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(233, 44),
                    backgroundColor: Color(0xFF262626),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: CommonText.titleMedium(btnTitle,
                      fontWeight: FontWeight.w600, color: Color(0xff98989A)),
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
