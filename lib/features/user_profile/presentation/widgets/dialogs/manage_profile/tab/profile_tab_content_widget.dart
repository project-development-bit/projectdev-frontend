part of '../manage_profile_dialog.dart';

String _maskEmail(String email) {
  if (email.isEmpty) return email;

  final parts = email.split('@');
  if (parts.length != 2) return email;

  final username = parts[0];
  final domain = parts[1];

  if (username.length <= 2) {
    return '${username[0]}***@$domain';
  }

  // Show first few characters and mask the rest
  final visibleChars = username.length <= 5 ? 1 : username.length ~/ 3;
  final maskedUsername = '${username.substring(0, visibleChars)}***';

  return '$maskedUsername@$domain';
}

String _maskOfferToken(String token) {
  if (token.isEmpty) return token;
  if (token.length <= 6) return token;

  // Show first 3 and last 3 characters
  return '${token.substring(0, 3)}...${token.substring(token.length - 3)}';
}

final _showOfferTokenProvider = StateProvider.autoDispose<bool>((ref) => false);

class ProfileTabContent extends ConsumerWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(profileCurrentUserProvider)?.email ?? '';
    final account = ref.watch(getProfileNotifierProvider).profile?.account;
    final name = ref.watch(profileCurrentUserProvider)?.name ?? '';
    final offerToken =
        ref.watch(getProfileNotifierProvider).profile?.account.offerToken ?? '';
    final showOfferToken = ref.watch(_showOfferTokenProvider);
    // final currentLocale = ref.watch(localeProvider);
    // final country = ref.watch(profileCurrentUserProvider)?.country ?? '';
    final isMobile = context.screenWidth < 600;
    return Column(
      children: [
        _profileTabContentItem(
          title: context.translate("avatar"),
          child: UserProfileImageWidget(size: 25),
          btnTitle: context.translate("change_your_avatar"),
          onPressed: () {
            context.pop();
            showUploadAvatarDialog(context);
          },
          isMobile: isMobile,
        ),
        _profileTabContentItem(
          title: context.translate("name"),
          child: CommonText.bodyMedium(
            name.isNotEmpty ? name : context.translate("no_name_set"),
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          btnTitle: context.translate("change_your_name"),
          onPressed: () {
            showChangeNameDialog(context);
          },
          isMobile: isMobile,
        ),
        _profileTabContentItem(
          title: context.translate("email"),
          child: email.isNotEmpty
              ? CommonText.bodyMedium(
                  _maskEmail(email),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )
              : CommonText.bodyMedium(
                  context.translate("no_email_set"),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
          btnTitle: context.translate("change_your_email"),
          onPressed: () {
            showChangeEmailDialog(context);
          },
          isMobile: isMobile,
        ),
        _profileTabContentItem(
          title: context.translate("country"),
          child: account?.country != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonImage(
                      imageUrl: account!.country!.flag,
                      width: 21,
                      height: 10,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    CommonText.bodyMedium(
                      account.country!.name,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ],
                )
              : CommonText.bodyMedium(
                  context.translate("no_country_set"),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
          btnTitle: context.translate("change_your_country"),
          onPressed: () {
            showChangeCountryDialog(context);
          },
          isMobile: isMobile,
        ),
        _profileTabContentItem(
          title: context.translate("offer_token"),
          child: CommonText.bodyMedium(
            offerToken.isNotEmpty
                ? (showOfferToken ? offerToken : _maskOfferToken(offerToken))
                : context.translate("no_offer_token"),
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          btnTitle: context.translate(
              showOfferToken ? "hide_offer_token" : "show_offer_token"),
          onPressed: () {
            ref.read(_showOfferTokenProvider.notifier).state = !showOfferToken;
          },
          isMobile: isMobile,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
              if (!context.isMobile)
              Expanded(
                  child: CommonText.titleMedium(
                "",
                fontWeight: FontWeight.w700,
              )),
              Expanded(
                flex: 4,
                child: CommonText.bodyMedium(
                    context.translate("offer_token_description"),
                    color: Color(0xff98989A)),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _profileTabContentItem(
      {required String title,
      required Widget child,
      required String btnTitle,
      required Function() onPressed,
      required bool isMobile}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: isMobile
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
                    child
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
                    fontColor: const Color.fromARGB(255, 99, 99, 130),
                    backgroundColor: const Color(0xFF262626),
                  ),
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 21.0,
              children: [
                Expanded(
                    child: CommonText.bodyLarge(
                  title,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
                Expanded(
                  flex: 2,
                  child: Align(alignment: Alignment.centerLeft, child: child),
                ),
                Expanded(
                  flex: 2,
                  child: CustomUnderLineButtonWidget(
                    title: btnTitle,
                    onTap: onPressed,
                    isDark: true,
                    backgroundColor: const Color(0xFF262626),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
    );
  }
}
