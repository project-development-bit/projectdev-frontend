import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/widgets/responsive_container.dart';

/// Section explaining how the platform works
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSection(
      backgroundColor: context.surface,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          // Section header
          CommonText.headlineMedium(
            context.translate('how_it_works_heading'),
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          CommonText.headlineSmall(
            context.translate('how_it_works_subheading'),
            textAlign: TextAlign.center,
            color: context.onSurfaceVariant,
          ),
          const SizedBox(height: 48),

          // Steps
          if (context.isMobile)
            // Mobile: Vertical layout
            Column(
              children: [
                _buildStep(context, 1, context.translate('choose_offer'),
                    context.translate('choose_offer_desc')),
                const SizedBox(height: 40),
                _buildStep(context, 2, context.translate('complete_offer'),
                    context.translate('complete_offer_desc')),
                const SizedBox(height: 40),
                _buildStep(context, 3, context.translate('get_paid_instantly'),
                    context.translate('get_paid_instantly_desc')),
              ],
            )
          else
            // Desktop/Tablet: Horizontal layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildStep(
                      context,
                      1,
                      context.translate('choose_offer'),
                      context.translate('choose_offer_desc')),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildStep(
                      context,
                      2,
                      context.translate('complete_offer'),
                      context.translate('complete_offer_desc')),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildStep(
                      context,
                      3,
                      context.translate('get_paid_instantly'),
                      context.translate('get_paid_instantly_desc')),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, int stepNumber, String title, String description) {
    return Column(
      crossAxisAlignment: context.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Step number circle
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.primary,
            boxShadow: [
              BoxShadow(
                color: context.primary.withAlpha(77), // 0.3 * 255
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: CommonText.titleLarge(
              stepNumber.toString(),
              color: context.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Title
        CommonText.titleLarge(
          title,
          textAlign: context.isMobile ? TextAlign.center : TextAlign.start,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 12),

        // Description
        CommonText.bodyMedium(
          description,
          textAlign: context.isMobile ? TextAlign.center : TextAlign.start,
          color: context.onSurfaceVariant,
        ),

        // Visual indicator (arrow for desktop)
        if (!context.isMobile && stepNumber < 3) ...[
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.arrow_forward,
              color: context.primary,
              size: 32,
            ),
          ),
        ],
      ],
    );
  }
}
