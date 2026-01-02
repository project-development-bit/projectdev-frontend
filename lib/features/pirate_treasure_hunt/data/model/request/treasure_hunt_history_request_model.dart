class TreasureHuntHistoryRequestModel {
  final int page;
  final int limit;

  const TreasureHuntHistoryRequestModel({
    this.page = 1,
    this.limit = 8,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
      };

  TreasureHuntHistoryRequestModel copyWith({
    int? page,
    int? limit,
  }) {
    return TreasureHuntHistoryRequestModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}
