import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/context_extensions.dart';
import 'package:cointiply_app/core/widgets/recaptcha_widget.dart';
import 'package:flutter/material.dart';

class CointiplyTutorialDialog extends StatefulWidget {
  final VoidCallback onComplete;
  const CointiplyTutorialDialog({super.key, required this.onComplete});

  @override
  State<CointiplyTutorialDialog> createState() =>
      _CointiplyTutorialDialogState();
}

class _CointiplyTutorialDialogState extends State<CointiplyTutorialDialog> {
  int step = 1;
  final int totalSteps = 9;

  final List<Map<String, dynamic>> steps = [
    {
      'title': 'welcome_to_cointiply',
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

    return Dialog(
      backgroundColor: const Color(0xFF181818),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, minWidth: 320),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.titleSmall(
                    context.translate(data['title']),
                    color: context.inverseSurface,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CommonText.labelMedium(
                      context.translate('dismiss_hide'),
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey[700]),
              const SizedBox(height: 20),

              // ─── Icon or Gradient Title ────────────────
              Center(
                child: data['gradient'] == true
                    ? ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFFF007F),
                            Color(0xFF7F00FF),
                            Color(0xFF00FFFF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
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
                const SizedBox(height: 20),
                // Center(
                //   child: CommonText.titleSmall(
                //     context.translate('captcha_selection'),
                //     color: context.inverseSurface,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _buildCaptchaOption(context.translate('hcaptcha'), false),
                //     const SizedBox(width: 12),
                //     _buildCaptchaOption(context.translate('recaptcha'), true),
                //   ],
                // ),
                const SizedBox(height: 10),
                RecaptchaWidget(),
                const SizedBox(height: 20),
                // _buildCaptchaPreview(),
                const SizedBox(height: 24),
                _buildRewardBox(),
              ],

              const SizedBox(height: 24),
              Divider(color: Colors.grey[700]),
              const SizedBox(height: 16),

              // ─── Footer ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.labelMedium(
                    context
                        .translate('step_of')
                        .replaceAll('{step}', '$step')
                        .replaceAll('{totalSteps}', '$totalSteps'),
                    color: Colors.white70,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed:
                            step > 1 ? () => setState(() => step--) : null,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[500],
                        ),
                        child: CommonText.labelMedium(
                          context.translate('back'),
                          color: step > 1 ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (step < totalSteps) {
                            setState(() => step++);
                          } else {
                            widget.onComplete();
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: data['final'] == true
                              ? Colors.blueAccent
                              : const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: CommonText.labelMedium(
                          step == totalSteps
                              ? context.translate('claim_tutorial_reward')
                              : context.translate('continue'),
                          color: Colors.white,
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

  // ─── Captcha Option Widget ────────────────────────────────
  // Widget _buildCaptchaOption(String label, bool selected) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: selected ? const Color(0xFFE91E63) : const Color(0xFF2C2C2C),
  //       borderRadius: BorderRadius.circular(6),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //     child: CommonText.bodySmall(
  //       label,
  //       color: selected ? Colors.white : Colors.white70,
  //     ),
  //   );
  // }

  // ─── Tutorial Reward Box ────────────────────────────────
  Widget _buildRewardBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE91E63)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.titleSmall(
            context.translate('tutorial_reward'),
            color: const Color(0xFFE91E63),
          ),
          const SizedBox(height: 6),
          CommonText.bodySmall(
            context.translate('tutorial_reward_desc'),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
