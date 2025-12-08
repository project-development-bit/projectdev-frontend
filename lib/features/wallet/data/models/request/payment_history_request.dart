class PaymentHistoryRequest {
  final String? status;
  final String? type;
  final int page;
  final int limit;

  PaymentHistoryRequest({
    this.status,
    this.type,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'page': page,
      'limit': limit,
      'type': type,
    };
  }

  PaymentHistoryRequest copyWith({
    String? status,
    int? page,
    int? limit,
    String? type,
  }) {
    return PaymentHistoryRequest(
      status: status ?? this.status,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      type: type ?? this.type,
    );
  }

  String toRequestUrl() {
    final params = <String>[];
    if (status != null) {
      params.add('status=$status');
    }
    params.add('page=$page');
    params.add('limit=$limit');
    if (type != null) {
      params.add('type=$type');
    }
    return params.join('&');
  }
}
