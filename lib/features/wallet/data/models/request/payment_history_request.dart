class PaymentHistoryRequest {
  final String? status;
  final String? transactionType;
  final String? filterCurrency;
  final int page;
  final int limit;

  PaymentHistoryRequest({
    this.status,
    this.transactionType,
    this.filterCurrency,
    required this.page,
    required this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'page': page,
      'limit': limit,
      'transactionType': transactionType,
      'currency': filterCurrency,
    };
  }

  PaymentHistoryRequest copyWith({
    String? status,
    int? page,
    int? limit,
    String? transactionType,
  }) {
    return PaymentHistoryRequest(
      status: status ?? this.status,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  String toRequestUrl() {
    final params = <String>[];
    if (status != null) {
      params.add('status=$status');
    }
    params.add('page=$page');
    params.add('limit=$limit');
    if (transactionType != null) {
      params.add('transactionType=$transactionType');
    }
    if (filterCurrency != null) {
      params.add('currency=$filterCurrency');
    }
    return params.join('&');
  }
}
