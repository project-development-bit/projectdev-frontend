class ClaimFaucetRequestModel {
  final String? deviceFingerprint;
  final String turnstileToken;

  const ClaimFaucetRequestModel({
    this.deviceFingerprint,
    required this.turnstileToken,
  });

  Map<String, dynamic> toJson() => {
        if (deviceFingerprint != null) 'device_fingerprint': deviceFingerprint,
        'turnstileToken': turnstileToken,
      };
}
