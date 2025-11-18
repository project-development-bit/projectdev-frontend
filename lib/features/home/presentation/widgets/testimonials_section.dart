import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/common/common_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../providers/home_providers.dart';

/// Section displaying user testimonials
class TestimonialsSection extends ConsumerWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimonials = ref.watch(testimonialsProvider);

    return ResponsiveSection(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          CommonText.headlineMedium(
            context.translate('what_users_say'),
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          CommonText.bodyMedium(
            context.translate('real_earnings'),
            color: context.onSurfaceVariant,
          ),
          const SizedBox(height: 32),

          // Testimonials
          if (context.isMobile)
            // Mobile: Vertical scrollable list
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: testimonials.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: context.screenWidth * 0.8,
                    child: _TestimonialCard(testimonial: testimonials[index]),
                  );
                },
              ),
            )
          else
            // Desktop/Tablet: Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.isTablet ? 2 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              itemCount: testimonials.length,
              itemBuilder: (context, index) {
                return _TestimonialCard(testimonial: testimonials[index]);
              },
            ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  const _TestimonialCard({
    required this.testimonial,
  });

  final dynamic
      testimonial; // Using dynamic for now, should be TestimonialModel

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with badge, level, and username
            Row(
              children: [
                // Badge and level
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText.bodySmall(
                        testimonial.badge,
                        fontSize: 12,
                      ),
                      const SizedBox(width: 4),
                      CommonText.bodySmall(
                        'LEVEL ${testimonial.level}',
                        color: context.onPrimaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CommonText.bodySmall(
                  testimonial.timeAgo,
                  color: context.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Message
            Expanded(
              child: CommonText.bodyMedium(
                testimonial.message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),

            // Footer with username
            Row(
              children: [
                CommonText.bodySmall(
                  '— ${testimonial.username}',
                  color: context.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                const Spacer(),
                // Earnings indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withAlpha(26), // 0.1 * 255
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CommonText.bodySmall(
                    '+\$${testimonial.earning.toStringAsFixed(0)}',
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
