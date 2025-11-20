import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/theme/presentation/providers/app_setting_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBannerSection extends ConsumerWidget {
  const HomeBannerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannersConfigProvider);

    final image = Image.asset(
      'assets/images/bg/test_banner.png',
      width: double.infinity,
      height: 350,
      fit: BoxFit.cover,
    );
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: CommonImage(
        imageUrl: banners.isNotEmpty ? banners.first.image : '',
        width: double.infinity,
        height: 350,
        fit: BoxFit.cover,
        errorWidget: image,
        loadingWidget: image,
      ),
    );
  }
}
