class EarningsHistoryRequestModel {
  const EarningsHistoryRequestModel({
    this.page,
    this.limit,
    this.days,
    this.category,
  });
  final int? page;
  final int? limit;
  final int? days;
  final String? category;

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (days != null) params['days'] = days;
    if (category != null && category!.isNotEmpty) {
      params['category'] = category;
    }

    return params;
  }

  String toQueryString() {
    final params = toQueryParams();
    if (params.isEmpty) return '';

    final queryString = params.entries
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    return '?$queryString';
  }
}
