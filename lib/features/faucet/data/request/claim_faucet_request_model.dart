class ClaimFaucetRequestModel {
  final String deviceFingerprint;
  final String turnstileToken;

  const ClaimFaucetRequestModel({
    required this.deviceFingerprint,
    required this.turnstileToken,
  });

  Map<String, dynamic> toJson() => {
        'device_fingerprint': deviceFingerprint,
        'turnstileToken': turnstileToken,
      };
}
