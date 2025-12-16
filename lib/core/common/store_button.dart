import 'package:cointiply_app/core/config/app_local_images.dart';
import 'package:flutter/material.dart';

enum StoreButtonType { googlePlay, appStore }

class GigaStoreButton extends StatelessWidget {
  final StoreButtonType type;
  final VoidCallback? onTap;

  const GigaStoreButton({
    super.key,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGoogle = type == StoreButtonType.googlePlay;

    final iconAsset = isGoogle
        ? AppLocalImages.googlePlayButton
        : AppLocalImages.appStoreButton;

    return InkWell(
      onTap: onTap,
      child: Image.asset(
        iconAsset,
        width: 150,
        height: 50,
        alignment: Alignment.centerLeft,
        fit: BoxFit.fill,
      ),
    );
  }
}
