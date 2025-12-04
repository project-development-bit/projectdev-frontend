import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showOfferTokenDialog(BuildContext context, {required String offerToken}) {
  context.showManagePopup(
    barrierDismissible: false,
    child: OfferTokenDialog(offerToken: offerToken),
  );
}

class OfferTokenDialog extends ConsumerStatefulWidget {
  final String offerToken;
  const OfferTokenDialog({super.key, required this.offerToken});

  @override
  ConsumerState<OfferTokenDialog> createState() => _OfferTokenDialogState();
}

class _OfferTokenDialogState extends ConsumerState<OfferTokenDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogBgWidget(
        title: context.translate("your_offer_token"),
        dialogHeight: context.isMobile ? 320 : 280,
        body: _dialogBgWidget());
  }

  Widget _dialogBgWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: context.isDesktop
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText.bodyLarge(
              context.translate("offer_token_description"),
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            if (context.isMobile || context.isTablet) ...[
              CommonText.bodyLarge(
                context.translate("your_offer_token"),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              offerTokenWidget(),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    child: CommonText.bodyLarge(
                      context.translate("your_offer_token"),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Flexible(
                    child: offerTokenWidget(),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            CommonText.bodyLarge(
              context.translate("offer_token_note"),
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Container offerTokenWidget() {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff1A1A1A),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CommonText.bodyLarge(
            widget.offerToken,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.offerToken));
              context.showSnackBar(
                  message: context.translate("copied_to_clipboard"));
            },
            icon: Icon(
              Icons.copy,
              color:Color(0xff333333),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
