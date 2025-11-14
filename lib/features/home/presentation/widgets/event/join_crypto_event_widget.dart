import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class JoinCryptoEventWidget extends StatelessWidget {
  const JoinCryptoEventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/gigafaucet_logo.png',
          width: 120,
          height: 120,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xff91A9FB).withAlpha(51),

                  /// TODO: Use constant
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CommonText.bodyLarge(
                  context.translate('earn_play_and_collect_crypto_text'),
                  fontWeight: FontWeight.w600,
                ),
              ),
              CommonText.titleLarge(
                context.translate('join_crypto_event_widget_text'),
                fontSize: 40.0,
              ),
              CommonText.bodyLarge(context.translate("join_crypto_event_description_widget_text"))
            ],
          ),
        ),
      ],
    );
  }
}
