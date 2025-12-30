class UncoverTreasureRequestModel {
  final String turnstileToken;

  const UncoverTreasureRequestModel({
    required this.turnstileToken,
  });

  Map<String, dynamic> toJson() => {
        'turnstileToken': turnstileToken,
      };
}
