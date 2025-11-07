import 'package:equatable/equatable.dart';

/// Pure domain entity — independent of data layer
class ReferalBannerEntity extends Equatable {
  final String imageUrl;
  final int width;
  final int height;
  final String format;

  const ReferalBannerEntity({
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.format,
  });

  @override
  List<Object?> get props => [imageUrl, width, height, format];
}
