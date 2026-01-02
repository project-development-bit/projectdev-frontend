class CollectTreasureRequestModel {
  final String turnstileToken;

  const CollectTreasureRequestModel({
    required this.turnstileToken,
  });

  Map<String, dynamic> toJson() => {
        'turnstileToken': turnstileToken,
      };
}
