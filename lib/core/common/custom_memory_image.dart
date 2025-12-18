import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomMemoryImage extends StatefulWidget {
  final String assetPath; // path to asset to load into memory
  final BoxFit fit;
  final FilterQuality filterQuality;
  final double? width;
  final double? height;

  const CustomMemoryImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.high,
    this.width,
    this.height,
  });

  @override
  State<CustomMemoryImage> createState() => _CustomMemoryImageState();
}

class _CustomMemoryImageState extends State<CustomMemoryImage> {
  Future<Uint8List> _load() async {
    final data = await rootBundle.load(widget.assetPath);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }

        return Image.memory(
          snapshot.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          filterQuality: widget.filterQuality,
        );
      },
    );
  }
}
