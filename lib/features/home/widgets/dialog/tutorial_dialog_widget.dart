import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/theme/app_colors.dart';
import 'package:cointiply_app/core/widgets/cloudflare_turnstille_widgte.dart';
import 'package:cointiply_app/features/home/providers/tutorial_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstTimeTutorialDialog extends StatefulWidget {
  final VoidCallback onComplete;
  const FirstTimeTutorialDialog({super.key, required this.onComplete});

  @override
  State<FirstTimeTutorialDialog> createState() =>
      _FirstTimeTutorialDialogState();
}

class _FirstTimeTutorialDialogState extends State<FirstTimeTutorialDialog> {
  int step = 1;
  final int totalSteps = 9;

  final List<Map<String, dynamic>> steps = [
    {
      'title': 'welcome_to_gigafaucet',
      'image': 'assets/tutorial/welcome.png',
      'gradient': true,
      'description': 'welcome_description',
    },
    {
      'title': 'free_spins_and_mystery_boxes',
      'image': 'assets/tutorial/spin.png',
      'description': 'free_spins_description',
    },
    {
      'title': 'daily_streak',
      'image': 'assets/tutorial/streak.webp',
      'description': 'daily_streak_description',
    },
    {
      'title': 'ptc_ads',
      'image': 'assets/tutorial/ptc.jpg',
      'description': 'ptc_ads_description',
    },
    {
      'title': 'missions_and_quests',
      'image': 'assets/tutorial/missions.png',
      'description': 'missions_description',
    },
    {
      'title': 'completing_offers',
      'image': 'assets/tutorial/offers.png',
      'description': 'offers_description',
    },
    {
      'title': 'xp_points',
      'image': 'assets/tutorial/xp.png',
      'description': 'xp_description',
    },
    {
      'title': 'withdrawing_coins',
      'image': 'assets/tutorial/withdraw.png',
      'description': 'withdraw_description',
    },
    {
      'title': 'you_are_all_set',
      'image': 'assets/tutorial/reward.png',
      'description': 'all_set_description',
      'final': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final data = steps[step - 1];
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.all(context.isMobile ? 20 : 32),
      constraints: BoxConstraints(
        minHeight: context.heightPercent(35),
        maxWidth: context.isMobile
            ? double.infinity
            : context.isTablet
                ? context.widthPercent(50)
                : context.widthPercent(40),
        maxHeight: context.isMobile
            ? double.infinity
            : context.isTablet
                ? context.heightPercent(80)
                : context.heightPercent(70),
      ),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(context.isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // ─── Header ────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Expanded title to prevent overflow
                  Expanded(
                    child: CommonText.titleSmall(
                      context.translate(data['title']),
                      color: context.inverseSurface,
                      fontSize: context.isMobile ? 13 : 14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Consumer(
                    builder: (context, ref, child) {
                      return GestureDetector(
                        onTap: () =>
                            ref.read(tutorialProvider.notifier).closes(),
                        child: CommonText.labelMedium(
                          context.translate('dismiss_hide'),
                          color: colorScheme.primary,
                          fontSize: context.isMobile ? 12 : 13,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: colorScheme.outline),
              const SizedBox(height: 20),

              // ─── Icon or Gradient Title ────────────────
              Center(
                child: data['gradient'] == true
                    ? ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.welcomeGradient.createShader(bounds),
                        child: CommonText.displayMedium(
                          'WELCOME',
                          color: context.inverseSurface,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Image.asset(
                        data['image'],
                        height: 110,
                      ),
              ),
              const SizedBox(height: 24),

              // ─── Description ───────────────────────────
              CommonText.bodyMedium(
                context.translate(data['description']),
                color: context.inverseSurface,
                maxLines: 20,
              ),

              // ─── Captcha + Reward for Final Step ────────
              if (data['final'] == true) ...[
                const SizedBox(height: 10),
                const CloudflareTurnstileWidget(debugMode: false),
                const SizedBox(height: 24),
                _buildRewardBox(context),
              ],

              const SizedBox(height: 24),
              Divider(color: colorScheme.outline),
              const SizedBox(height: 16),

              // ─── Footer ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CommonText.labelMedium(
                      context
                          .translate('step_of')
                          .replaceAll('{step}', '$step')
                          .replaceAll('{totalSteps}', '$totalSteps'),
                      color: colorScheme.tertiary,
                      fontSize: context.isMobile ? 13 : 14,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed:
                            step > 1 ? () => setState(() => step--) : null,
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.primary,
                        ),
                        child: CommonText.labelMedium(
                          context.translate('back'),
                          color: colorScheme.inverseSurface,
                        ),
                      ),
                      SizedBox(width: context.isMobile ? 4 : 8),
                      ElevatedButton(
                        onPressed: () {
                          if (step < totalSteps) {
                            setState(() => step++);
                          } else {
                            widget.onComplete();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: data['final'] == true
                              ? colorScheme.tertiary
                              : colorScheme.primary,
                          foregroundColor: colorScheme.inversePrimary,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.isMobile ? 8 : 20,
                            vertical: context.isMobile ? 8 : 12,
                          ),
                        ),
                        child: CommonText.labelMedium(
                          step == totalSteps
                              ? context.translate('claim_tutorial_reward')
                              : context.translate('continue'),
                          color: AppColors.lightSurfaceVariant,
                          fontSize: context.isMobile ? 12 : 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Tutorial Reward Box ────────────────────────────────
  Widget _buildRewardBox(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.error),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.titleSmall(
            context.translate('tutorial_reward'),
            color: colorScheme.error,
          ),
          const SizedBox(height: 6),
          CommonText.bodySmall(
            context.translate('tutorial_reward_desc'),
            color: colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}
