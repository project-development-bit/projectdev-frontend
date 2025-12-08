import 'dart:developer';

import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

showAffiliateProgramDialog(BuildContext context) {
  context.showAffiliateProgramPopup(
    barrierDismissible: false,
    child: const AffiliateProgramDialog(),
  );
}

class AffiliateProgramDialog extends StatefulWidget {
  const AffiliateProgramDialog({super.key});

  @override
  State<AffiliateProgramDialog> createState() => _AffiliateProgramDialogState();
}

class _AffiliateProgramDialogState extends State<AffiliateProgramDialog> {
  final socialIconList = [
    {
      'iconPath': 'assets/images/icons/facebook.svg',
      'name': 'facebook',
    },
    {
      'iconPath': 'assets/images/icons/gmail.svg',
      'name': 'gmail',
    },
    {
      'iconPath': 'assets/images/icons/whatsapp.svg',
      'name': 'whatsapp',
    },
    {
      'iconPath': 'assets/images/icons/linkedin.svg',
      'name': 'linkedin',
    },
    {
      'iconPath': 'assets/images/icons/twitter.svg',
      'name': 'twitter',
    },
    {
      'iconPath': 'assets/images/icons/telegram.svg',
      'name': 'telegram',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DialogBgWidget(
        body: _dialogBody(),
        title: context.translate("affiliate_program_title"));
  }

  Widget _dialogBody() {
    return SingleChildScrollView(
      padding: context.isDesktop
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.bodyMedium(
            context.translate("affiliate_program_description"),
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 24),
          _referralLinkSection(),
          const SizedBox(height: 15),
          _referralInfoSection(),
        ],
      ),
    );
  }

  Container _referralLinkSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.5),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff333333)),
        image: DecorationImage(
          image: AssetImage('assets/images/trophy.png'),
          alignment: Alignment(0, 0),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          CommonText.headlineSmall(context.translate("referral_link"),
              fontWeight: FontWeight.w700, color: context.primary),
          Container(
            constraints: BoxConstraints(maxWidth: 380),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xff1A1A1A),

                /// TODO: replace with design system color
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CommonText.bodyMedium(
                      'https://gigafaucet.com/referral/yourname',
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: 'https://gigafaucet.com/referral/yourname'));
                      context.showSnackBar(
                          message: context
                              .translate("referral_link_copied_message"));
                    },
                    icon: Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 24,
                    ))
              ],
            ),
          ),
          CommonText.bodyMedium(
            context.translate("share"),
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          Wrap(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                for (var socialIcon in socialIconList)
                  _socialIcon(
                      iconPath: socialIcon['iconPath']!,
                      onTap: () {
                        log('${socialIcon['name']} icon tapped');
                      }),
              ])
        ],
      ),
    );
  }

  Widget _socialIcon({required String iconPath, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14.5),
        alignment: Alignment.center,
        width: 44,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff333333), width: 1),
          shape: BoxShape.circle,
          color: Color(0xff00131E).withAlpha((255 * 0.8).toInt()),
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          width: 13,
          height: 13,
        ),
      ),
    );
  }

  Widget _referralInfoSection() {
    final isMobile = context.isMobile;

    return GridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: isMobile ? 2 : 4),
      children: [
        _infoItem(
            assetPath: "assets/images/money_bag.png",
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium("200",
                    fontWeight: FontWeight.w700, color: context.primary),
                const SizedBox(width: 4),
                Image.asset(
                  "assets/images/rewards/coin.png",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
            label: context.translate("referral_earnings")),
        _infoItem(
            assetPath: "assets/images/referral_person.png",
            value: CommonText.titleMedium("5",
                fontWeight: FontWeight.w700, color: context.primary),
            label: context.translate("referral_users")),
        _infoItem(
            assetPath: "assets/images/sand_watch.png",
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium("200",
                    fontWeight: FontWeight.w700, color: context.primary),
                const SizedBox(width: 4),
                Image.asset(
                  "assets/images/rewards/coin.png",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
            label: context.translate("pending_earnings")),
        _infoItem(
            assetPath: "assets/images/week.png",
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium("200",
                    fontWeight: FontWeight.w700, color: context.primary),
                const SizedBox(width: 4),
                Image.asset(
                  "assets/images/rewards/coin.png",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
            label: context.translate("active_this_week")),
      ],
    );
  }

  Widget _infoItem(
      {required String assetPath,
      required Widget value,
      required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff00131E).withAlpha((255 * 0.8).toInt()),
        border: Border.all(color: Color(0xff333333)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            height: 37,
          ),
          SizedBox(height: 10),
          value,
          const SizedBox(height: 8),
          CommonText.bodyMedium(
            label,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
