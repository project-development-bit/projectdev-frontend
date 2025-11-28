import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../extensions/context_extensions.dart';

/// A common image widget that handles network images with loading and error states
class CommonImage extends StatefulWidget {
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
  State<CommonImage> createState() => _CommonImageState();
}

class _CommonImageState extends State<CommonImage> {
  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    final defaultLoadingWidget = widget.loadingWidget ??
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.secondaryContainer
                : context.surfaceContainer,
            borderRadius: widget.borderRadius,
          ),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(colorScheme.primary),
            ),
          ),
        );

    final defaultErrorWidget = widget.errorWidget ??
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.tertiaryContainer.withValues(alpha: 0.5)
                : context.errorContainer,
            borderRadius: widget.borderRadius,
          ),
          child: Icon(
            Icons.image_not_supported_outlined,
            color: isDark
                ? colorScheme.onPrimaryContainer
                : context.onErrorContainer,
            size: (widget.width != null && widget.height != null)
                ? (widget.width! < widget.height!
                    ? widget.width! * 0.4
                    : widget.height! * 0.4)
                : 24,
          ),
        );

    Widget imageWidget;

    if (widget.imageUrl.isEmpty) {
      imageWidget = defaultErrorWidget;
    } else if (widget.imageUrl.startsWith('http')) {
      imageWidget = CachedNetworkImage(
        imageUrl: widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        placeholder: widget.placeholder != null
            ? (context, url) {
                if (!mounted) return const SizedBox.shrink();
                return widget.placeholder!;
              }
            : null,
        errorWidget: (context, url, error) {
          if (!mounted) return const SizedBox.shrink();
          return defaultErrorWidget;
        },
        progressIndicatorBuilder: widget.placeholder != null
            ? null
            : widget.loadingWidget != null
                ? (context, url, progress) {
                    if (!mounted) return const SizedBox.shrink();
                    return widget.loadingWidget!;
                  }
                : (context, url, progress) {
                    if (!mounted) return const SizedBox.shrink();
                    return defaultLoadingWidget;
                  },
      );
    } else {
      // Handle asset images
      imageWidget = Image.asset(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) {
          if (!mounted) return const SizedBox.shrink();
          return defaultErrorWidget;
        },
      );
    }

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
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
