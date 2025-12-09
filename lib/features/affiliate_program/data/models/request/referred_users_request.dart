class ReferredUsersRequest {
  final int page;
  final int limit;
  final String? dateFrom;
  final String? dateTo;
  final String? search;

  ReferredUsersRequest({
    required this.page,
    required this.limit,
    this.dateFrom,
    this.dateTo,
    this.search,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'search': search,
    };
  }

  ReferredUsersRequest copyWith({
    int? page,
    int? limit,
    String? dateFrom,
    String? dateTo,
    String? search,
  }) {
    return ReferredUsersRequest(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      search: search ?? this.search,
    );
  }

  String toRequestUrl() {
    final params = <String>[];
    params.add('page=$page');
    params.add('limit=$limit');
    if (dateFrom != null && dateFrom!.isNotEmpty) {
      params.add('dateFrom=$dateFrom');
    }
    if (dateTo != null && dateTo!.isNotEmpty) {
      params.add('dateTo=$dateTo');
    }
    if (search != null && search!.isNotEmpty) {
      params.add('search=$search');
    }
    return params.join('&');
  }
}
