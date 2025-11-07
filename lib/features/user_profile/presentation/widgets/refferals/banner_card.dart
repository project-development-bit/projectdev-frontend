import 'package:cointiply_app/core/core.dart';
import 'package:cointiply_app/features/referrals/domain/entity/banner_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BannerCard extends StatelessWidget {
  final ReferalBannerEntity banner;

  const BannerCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BannerImage(banner: banner),
                const SizedBox(height: 16),
                BannerCodeFields(banner: banner),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: banner.width > 400 ? 6 : 5,
                  child: BannerImage(banner: banner),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: banner.width > 400 ? 7 : 6,
                  child: BannerCodeFields(banner: banner),
                ),
              ],
            ),
    );
  }
}

class BannerImage extends StatelessWidget {
  final ReferalBannerEntity banner;

  const BannerImage({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: banner.width / banner.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              banner.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                final proxy =
                    'https://images.weserv.nl/?url=${banner.imageUrl.replaceFirst('https://', '')}';
                return Image.network(proxy, fit: BoxFit.cover);
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        CommonText.bodySmall(
          '${banner.width}×${banner.height} – ${banner.format}',
          color: colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

class BannerCodeFields extends StatelessWidget {
  final ReferalBannerEntity banner;

  const BannerCodeFields({super.key, required this.banner});

  Future<void> copyToClipboard(BuildContext context, String text) async {
    final colorScheme = Theme.of(context).colorScheme;
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CommonText.bodySmall(
            'Copied to clipboard!',
            color: colorScheme.onPrimary,
          ),
          backgroundColor: colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const referralLink = 'https://cointiply.com/r/wkxnY1';

    final fields = [
      {
        'title': 'Banner URL',
        'code': banner.imageUrl,
      },
      {
        'title': 'HTML Code',
        'code':
            '<a href="$referralLink"><img src="${banner.imageUrl}" alt="Join Cointiply"></a>',
      },
      {
        'title': 'BB Code',
        'code': '[url=$referralLink][img]${banner.imageUrl}[/img][/url]',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.map((f) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.labelMedium(
                f['title']!,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () => copyToClipboard(context, f['code']!),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: CommonText.bodySmall(
                    f['code']!,
                    color: colorScheme.onSurfaceVariant,
                    maxLines: 3,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
