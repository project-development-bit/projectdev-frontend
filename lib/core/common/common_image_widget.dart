import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../extensions/context_extensions.dart';

/// A common image widget that handles network images with loading and error states
class CommonImage extends StatelessWidget {
  const CommonImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.loadingWidget,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final defaultLoadingWidget = loadingWidget ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.secondaryContainer
                : context.surfaceContainer,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
        );

    final defaultErrorWidget = errorWidget ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.tertiaryContainer.withValues(alpha: 0.5)
                : context.errorContainer,
            borderRadius: borderRadius,
          ),
          child: Icon(
            Icons.image_not_supported_outlined,
            color: isDark
                ? colorScheme.onPrimaryContainer
                : context.onErrorContainer,
            size: (width != null && height != null)
                ? (width! < height! ? width! * 0.4 : height! * 0.4)
                : 24,
          ),
        );

    Widget imageWidget;

    if (imageUrl.isEmpty) {
      imageWidget = defaultErrorWidget;
    } else if (imageUrl.startsWith('http')) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder:
            placeholder != null ? (context, url) => placeholder! : null,
        errorWidget: (context, url, error) => defaultErrorWidget,
        progressIndicatorBuilder: placeholder != null
            ? null
            : loadingWidget != null
            ? (context, url, progress) => loadingWidget!
            : (context, url, progress) => defaultLoadingWidget,
      );
    } else {
      // Handle asset images
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => defaultErrorWidget,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// A circular avatar image widget
class CommonAvatar extends StatelessWidget {
  const CommonAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.backgroundColor,
    this.placeholderText,
  });

  final String imageUrl;
  final double radius;
  final Color? backgroundColor;
  final String? placeholderText;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? context.primaryContainer,
        child: Text(
          placeholderText ?? '?',
          style: context.bodyMedium?.copyWith(
            color: context.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? context.primaryContainer,
      backgroundImage: imageUrl.startsWith('http')
          ? CachedNetworkImageProvider(imageUrl)
          : AssetImage(imageUrl) as ImageProvider,
      onBackgroundImageError: (exception, stackTrace) {},
      child: imageUrl.isEmpty
          ? Text(
              placeholderText ?? '?',
              style: context.bodyMedium?.copyWith(
                color: context.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}
