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
            title: context.translate("password"),
            btnTitle: context.translate("change_your_password"),
            isPrimaryColor: false,
            onPressed: () {
              context.pop();
              showChangePasswordDialog(context);
            }),
        _securityMenuItem(
            title: context.translate("twofa_authenticator_app"),
            onPressed: () {
              context.pop();
              if (is2FAEnabled) {
                showDisable2FAConfirmationDialog(
                  context,
                  onDisabled: () {
                    // Refresh profile data after disabling 2FA
                    ref
                        .read(getProfileNotifierProvider.notifier)
                        .fetchProfile(isLoading: false);
                  },
                );
              } else {
                show2FADialog(context, email: email, onSuccess: () {
                  // Refresh profile data after enabling 2FA
                  ref
                      .read(getProfileNotifierProvider.notifier)
                      .fetchProfile(isLoading: false);
                });
              }
            },
            isDanger: is2FAEnabled,
            btnTitle: is2FAEnabled
                ? context.translate("disable_2fa")
                : context.translate("enable_2fa"),
            description: context.translate("twofa_description")),
        _securityMenuItem(
            isDanger: isPinEnabled,
            title: context.translate("enable_security_pin"),
            btnTitle: isPinEnabled
                ? context.translate("disable_security_pin")
                : context.translate("enable_security_pin_btn"),
            onPressed: () {
              context.pop();
              showSecurityPinDialog(context, isPinEnabled: isPinEnabled);
            },
            description: context.translate("security_pin_description")),
      ],
    );
  }

  Widget _securityMenuItem(
      {required String title,
      required Function() onPressed,
      required String btnTitle,
      String? description,
      bool? isPrimaryColor,
      bool isDanger = false}) {
    final isMobile = context.isMobile;
    return isMobile
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 21.0,
                children: [
                  CommonText.bodyLarge(
                    title,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomUnderLineButtonWidget(
                  title: btnTitle,
                  onTap: onPressed,
                  fontColor: isDanger ? context.error : Color(0xff98989A),
                  isRed: isDanger,
                  isDark: true,
                  borderColor:
                      isDanger ? context.error.withValues(alpha: 0.3) : null,
                  fontSize: 14,
                  width: 233,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (description != null)
                Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: CommonText.bodyMedium(description,
                        color: Color(0xff98989A))),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 163,
                    child: CommonText.bodyLarge(title,
                        fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomUnderLineButtonWidget(
                        title: btnTitle,
                        onTap: onPressed,
                        fontColor: isDanger ? context.error : Color(0xff98989A),
                        isRed: (isPrimaryColor ?? false) ? false : isDanger,
                        isDark: (isPrimaryColor ?? false) ? false : true,
                        borderColor: isDanger
                            ? context.error.withValues(alpha: 0.3)
                            : null,
                        fontSize: 14,
                        width: 233,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: [
                      SizedBox(width: 163),
                      Expanded(
                        flex: 2,
                        child: CommonText.bodyMedium(description,
                            color: Color(0xff98989A)),
                      )
                    ],
                  ),
                ),
            ],
          );
  }
}
