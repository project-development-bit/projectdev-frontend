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
            title: context.translate("change_password"),
            btnTitle: context.translate("change_password"),
            onPressed: () {
              showChangePasswordDialog(context);
            }),
        _securityMenuItem(
            title: context.translate("twofa_authenticator_app"),
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
            btnTitle: is2FAEnabled
                ? context.translate("disable_2fa")
                : context.translate("enable_2fa"),
            description: context.translate("twofa_description")),
        _securityMenuItem(
            title: context.translate("enable_security_pin"),
            btnTitle: isPinEnabled
                ? context.translate("disable_security_pin")
                : context.translate("enable_security_pin_btn"),
            onPressed: () {}),
      ],
    );
  }

  Widget _securityMenuItem(
      {required String title,
      required Function() onPressed,
      required String btnTitle,
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
