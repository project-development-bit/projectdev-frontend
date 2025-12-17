import 'package:gigafaucet/features/affiliate_program/data/models/referred_user_model.dart';
import 'package:gigafaucet/core/common/model/pagination_model.dart';

/// Domain entity for referred users result
class ReferredUsersResult {
  final String message;
  final List<ReferredUserModel> users;
  final PaginationModel pagination;

  const ReferredUsersResult({
    required this.message,
    required this.users,
    required this.pagination,
  });
}
