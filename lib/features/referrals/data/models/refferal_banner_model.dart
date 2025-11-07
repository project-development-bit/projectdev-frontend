import 'package:cointiply_app/features/referrals/domain/entity/banner_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refferal_banner_model.g.dart';

/// Represents a Cointiply promotional banner
@JsonSerializable(createFactory: true)
class RefferalBannerModel extends Equatable {
  /// Image URL of the banner
  final String image;

  /// Banner width (in pixels)
  final int width;

  /// Banner height (in pixels)
  final int height;

  /// File format (e.g., PNG, GIF, JPG)
  final String format;

  const RefferalBannerModel({
    required this.image,
    required this.width,
    required this.height,
    required this.format,
  });

  /// Factory to create instance from JSON
  factory RefferalBannerModel.fromJson(Map<String, dynamic> json) =>
      _$RefferalBannerModelFromJson(json);

  /// Convert instance to JSON
  Map<String, dynamic> toJson() => _$RefferalBannerModelToJson(this);

  @override
  List<Object?> get props => [image, width, height, format];

  @override
  String toString() => 'BannerModel(image: $image, ${width}x$height, $format)';

  ReferalBannerEntity toEntity() => ReferalBannerEntity(
        imageUrl: image,
        width: width,
        height: height,
        format: format,
      );
}
