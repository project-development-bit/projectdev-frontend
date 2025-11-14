import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/localization/app_localizations.dart';
import 'package:cointiply_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String number;
  final String totalEarn;

  const StatCard({
    super.key,
    required this.title,
    required this.number,
    required this.totalEarn,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Color(0x8000131E), // TODO use from colorScheme,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.titleMedium(
            title,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              // Number
              Row(
                children: [
                  CommonText.titleMedium(
                    localizations?.translate('number') ?? "Number",
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSecondary,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: CommonText.titleLarge(
                      number,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Total Earn
              Row(
                children: [
                  CommonText.titleMedium(
                    localizations?.translate('total_earn') ?? "Total Earn",
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSecondary,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.scrim,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        CommonText.titleLarge(
                          totalEarn,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 5),
                        Image(
                          image: const AssetImage(
                              "assets/images/rewards/coin.png"),
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
