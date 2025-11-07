import 'package:cointiply_app/features/referrals/data/datasources/referral_banner_remote_service.dart';
import 'package:cointiply_app/features/referrals/data/models/refferal_banner_model.dart';
import 'package:cointiply_app/features/referrals/domain/entity/banner_entity.dart';
import 'package:cointiply_app/features/referrals/domain/repository/referral_banner_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';

class ReferralBannerRepositoryImpl implements ReferralBannerRepository {
  final ReferralBannerRemoteService _remote;

  ReferralBannerRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<ReferalBannerEntity>>>
      getReferralBanners() async {
    try {
      debugPrint('🏪 ReferralBannerRepository: Starting banner fetch...');

      // final models = await _remote.getReferralBanners();
      // final entities = models.map((m) => m.toEntity()).toList();

      // debugPrint(
      //     '✅ ReferralBannerRepository: Successfully converted to entities');
      // debugPrint('🖼️ Loaded ${entities.length} banners');
      // for (final b in entities) {
      //   debugPrint('➡️ ${b.imageUrl} (${b.width}x${b.height}, ${b.format})');
      // }

      final banners = [
        RefferalBannerModel(
          image: 'https://cointiply.com/img/promo/banners/400x400_v2.png',
          width: 400,
          height: 400,
          format: 'PNG',
        ),
        RefferalBannerModel(
          image:
              'https://cointiply.com/img/promo/banners/800x400_animated_v1.gif',
          width: 800,
          height: 400,
          format: 'GIF',
        ),
      ];

      return Right(banners.map((b) => b.toEntity()).toList());
    } on DioException catch (e) {
      debugPrint('❌ ReferralBannerRepository: Dio exception: ${e.message}');

      String errorMessage = 'Failed to fetch referral banners';
      int statusCode = 500;

      if (e.response?.statusCode != null) {
        statusCode = e.response!.statusCode!;
      }

      if (e.response?.statusCode == 404) {
        errorMessage = 'Referral banner service not available';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Unable to connect to the server. Please try again later.';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      return Left(
        ServerFailure(
          message: errorMessage,
          statusCode: statusCode,
        ),
      );
    } catch (e) {
      debugPrint('❌ ReferralBannerRepository: Unexpected error: $e');
      return Left(
        ServerFailure(
          message:
              'An unexpected error occurred while fetching referral banners',
          statusCode: 500,
        ),
      );
    }
  }
}
