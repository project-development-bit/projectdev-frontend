import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
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
    this.loaingImageUrl,
    this.filterQuality,
    this.alignment,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final String? loaingImageUrl;
  final FilterQuality? filterQuality;
  final Alignment? alignment;
  @override
  State<CommonImage> createState() => _CommonImageState();
}

class _CommonImageState extends State<CommonImage> {
  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    final alignment = widget.alignment ?? Alignment.center;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

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

    final defaultLoadingWidget = widget.loadingWidget ??
        (widget.loaingImageUrl != null
            ? Image.asset(
                widget.loaingImageUrl!,
                width: widget.width,
                height: widget.height,
                filterQuality: widget.filterQuality ?? FilterQuality.high,
                fit: widget.fit,
                alignment: alignment,
                errorBuilder: (context, error, stackTrace) {
                  if (!mounted) return const SizedBox.shrink();
                  return defaultErrorWidget;
                },
              )
            : Container(
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
              ));
    Widget imageWidget;

    if (widget.imageUrl.isEmpty) {
      imageWidget = defaultErrorWidget;
    } else if (widget.imageUrl.startsWith('http')) {
      if (widget.imageUrl.endsWith('.svg')) {
        // Handle SVG images
        imageWidget = SizedBox(
          width: widget.width,
          height: widget.height,
          child: SvgPicture.network(
            widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            placeholderBuilder: widget.placeholder != null
                ? (context) {
                    if (!mounted) return const SizedBox.shrink();
                    return widget.placeholder!;
                  }
                : null,
            colorFilter: null,
          ),
        );
      } else {
        imageWidget = CachedNetworkImage(
          imageUrl: widget.imageUrl,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          filterQuality: widget.filterQuality ?? FilterQuality.high,
          // imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage,
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
      }
    } else if (widget.imageUrl.endsWith('.svg')) {
      // Handle SVG images
      imageWidget = SizedBox(
        width: widget.width,
        height: widget.height,
        child: SvgPicture.asset(
          widget.imageUrl,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          placeholderBuilder: widget.placeholder != null
              ? (context) {
                  if (!mounted) return const SizedBox.shrink();
                  return widget.placeholder!;
                }
              : null,
          colorFilter: null,
        ),
      );
    } else {
      // Handle asset images
      imageWidget = Image.asset(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: alignment,
        filterQuality: widget.filterQuality ?? FilterQuality.high,
        gaplessPlayback: true,
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
    this.alignment = Alignment.center,
  });

  final String imageUrl;
  final double radius;
  final Color? backgroundColor;
  final String? placeholderText;
  final Alignment alignment;

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

    final imageProvider = imageUrl.startsWith('http')
        ? CachedNetworkImageProvider(imageUrl)
        : AssetImage(imageUrl) as ImageProvider;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? context.primaryContainer,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          alignment: alignment,
          onError: (exception, stackTrace) {},
        ),
      ),
    );
  }
}
