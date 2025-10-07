import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/common/common_text.dart';

/// Section explaining how the platform works
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.surface,
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? 16 : 32,
        vertical: 60,
      ),
      child: Column(
        children: [
          // Section header
          CommonText.headlineMedium(
            'Start earning free crypto within minutes!',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          CommonText.headlineSmall(
            'Here\'s how...',
            textAlign: TextAlign.center,
            color: context.onSurfaceVariant,
          ),
          const SizedBox(height: 48),
          
          // Steps
          if (context.isMobile)
            // Mobile: Vertical layout
            Column(
              children: [
                _buildStep(context, 1, 'Choose an offer', 
                  'Take your pick from the tasks on the earn page. We list the best offers from companies who want to advertise their apps, surveys, and products.'),
                const SizedBox(height: 40),
                _buildStep(context, 2, 'Complete the offer', 
                  'Most offers are very simple and have already earned money for thousands of people. Most offers payout their first rewards within a few minutes.'),
                const SizedBox(height: 40),
                _buildStep(context, 3, 'Get paid instantly', 
                  'Once verified, your earnings are added to your account instantly. Withdraw via Bitcoin, LiteCoin, Doge or Dash.'),
              ],
            )
          else
            // Desktop/Tablet: Horizontal layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildStep(context, 1, 'Choose an offer', 
                    'Take your pick from the tasks on the earn page. We list the best offers from companies who want to advertise their apps, surveys, and products.'),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildStep(context, 2, 'Complete the offer', 
                    'Most offers are very simple and have already earned money for thousands of people. Most offers payout their first rewards within a few minutes.'),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _buildStep(context, 3, 'Get paid instantly', 
                    'Once verified, your earnings are added to your account instantly. Withdraw via Bitcoin, LiteCoin, Doge or Dash.'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, int stepNumber, String title, String description) {
    return Column(
      crossAxisAlignment: context.isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
                color: context.primary.withOpacity(0.3),
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