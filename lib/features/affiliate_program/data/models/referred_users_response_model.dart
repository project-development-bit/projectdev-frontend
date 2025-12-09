import 'package:cointiply_app/core/common/model/pagination_model.dart';
import 'package:cointiply_app/features/affiliate_program/data/models/referred_user_model.dart';

/// Data model for referred users response
class ReferredUsersResponseModel {
  final bool success;
  final String message;
  final List<ReferredUserModel> data;
  final PaginationModel pagination;

  const ReferredUsersResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory ReferredUsersResponseModel.fromJson(Map<String, dynamic> json) {
    return ReferredUsersResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ReferredUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(
          json['pagination'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
