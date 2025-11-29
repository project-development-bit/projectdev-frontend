class EarningsStatisticsRequest {
  const EarningsStatisticsRequest({this.days});
  final int? days;

  Map<String, dynamic> toQueryParams() {
    if (days == null) return {};
    return {'days': days};
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
