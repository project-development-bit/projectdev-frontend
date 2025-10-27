import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/common/common_text.dart';
import '../../../core/common/common_image_widget.dart';
import '../../../core/common/common_button.dart';
import '../models/offer_model.dart';

/// Widget to display an individual offer card
class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    this.onTap,
    this.showProgress = false,
  });

  final OfferModel offer;
  final VoidCallback? onTap;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header with image, title, and earning
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Offer image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CommonImage(
                          imageUrl: offer.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (offer.isHot)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CommonText.labelSmall(
                              'HOT',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Title and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.titleMedium(
                          offer.title,
                          fontWeight: FontWeight.w600,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CommonText.labelSmall(
                            offer.type.displayName,
                            color: context.onPrimaryContainer,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Earning amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CommonText.titleLarge(
                        '\$${offer.earning.toStringAsFixed(2)}',
                        color: context.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      if (offer.duration != null)
                        CommonText.bodySmall(
                          offer.duration!,
                          color: context.onSurfaceVariant,
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              CommonText.bodySmall(
                offer.description,
                color: context.onSurfaceVariant,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Progress bar (if applicable)
              if (showProgress && offer.progress != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: offer.progress! / 100,
                        backgroundColor: context.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation(context.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CommonText.bodySmall(
                      '${offer.progress!.toInt()}% Complete',
                      color: context.onSurfaceVariant,
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Footer with rating and action button
              Row(
                children: [
                  // Rating
                  if (offer.rating != null) ...[
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    CommonText.bodySmall(
                      offer.rating!.toStringAsFixed(1),
                      color: context.onSurfaceVariant,
                    ),
                    const Spacer(),
                  ] else
                    const Spacer(),

                  // Action button
                  CommonButton(
                    text: showProgress ? 'Continue' : 'Start Offer',
                    onPressed: onTap,
                    height: 32,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
