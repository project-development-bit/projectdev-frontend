import 'package:cointiply_app/features/earnings/domain/entity/earnings_pagination.dart';

class EarningsPaginationModel extends EarningsPagination {
  const EarningsPaginationModel({
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory EarningsPaginationModel.fromJson(Map<String, dynamic> json) {
    return EarningsPaginationModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': totalPages,
      };
}
