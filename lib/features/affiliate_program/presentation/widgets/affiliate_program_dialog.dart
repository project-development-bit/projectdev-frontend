import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          Container(
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
                                text:
                                    'https://gigafaucet.com/referral/yourname'));
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
                ),
                Wrap(spacing: 16, children: [_socialIcon()]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _socialIcon() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:Color(0xff00131E).withAlpha((255*0.8).toInt()),
      ),
      
    );
  }
}
