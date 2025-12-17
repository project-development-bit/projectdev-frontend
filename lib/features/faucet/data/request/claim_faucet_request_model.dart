class ClaimFaucetRequestModel {
  final String? deviceFingerprint;
  final String turnstileToken;
  final bool isPublic;

  const ClaimFaucetRequestModel({
    this.deviceFingerprint,
    required this.turnstileToken,
    this.isPublic = false,
  });

  Map<String, dynamic> toJson() => {
        if (deviceFingerprint != null) 'device_fingerprint': deviceFingerprint,
        'turnstileToken': turnstileToken,
      };
}
