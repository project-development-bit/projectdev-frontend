import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/terms_privacy_entity.dart';

abstract class TermsPrivacyRepository {
  Future<Either<Failure, TermsPrivacyEntity>> getTermsAndPrivacy();
}