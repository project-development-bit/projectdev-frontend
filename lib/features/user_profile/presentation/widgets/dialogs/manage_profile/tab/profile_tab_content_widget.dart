part of '../manage_profile_dialog.dart';

class ProfileTabContent extends ConsumerWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(profileCurrentUserProvider)?.email ?? '';
    // final country = ref.watch(profileCurrentUserProvider)?.country ?? '';
    return Column(
      children: [
        _profileTabContentItem(
          title: "Avatar",
          child: UserProfileImageWidget(size: 25),
          btnTitle: context.translate("change_your_avatar"),
          onPressed: () {
            context.pop();

            showUploadAvatarDialog(context);
          },
        ),
        _profileTabContentItem(
          title: "Email",
          child: email.isNotEmpty
              ? CommonText.bodyMedium(
                  email,
                  fontWeight: FontWeight.w500,
                )
              : CommonText.bodyMedium(
                  "No email set",
                  fontWeight: FontWeight.w500,
                ),
          btnTitle: context.translate("change_your_email"),
          onPressed: () {
            showChangeEmailDialog(context);
          },
        ),
        _profileTabContentItem(
          title: "Country",
          child: CommonText.bodyMedium(
            "No country set",
            fontWeight: FontWeight.w500,
          ),
          btnTitle: context.translate("change_your_country"),
          onPressed: () {
            showChangeCountryDialog(context);
          },
        ),
        _profileTabContentItem(
          title: "Offer Token",
          child: CommonText.bodyMedium(
            "95f...h45",
            fontWeight: FontWeight.w500,
          ),
          btnTitle: context.translate("show_offer_token"),
          onPressed: () {},
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12.0,
            children: [
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
      required Function() onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 21.0,
        children: [
          Expanded(
              child: CommonText.titleMedium(
            title,
            fontWeight: FontWeight.w700,
          )),
          Expanded(
            flex: 2,
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
          Expanded(
            flex: 2,
            child: CommonButton(
              width: 233,
              onPressed: onPressed,
              text: btnTitle,
              backgroundColor: Color(0xff333333),
              textColor: Color(0xff98989A),
            ),
          ),
        ],
      ),
    );
  }
}
