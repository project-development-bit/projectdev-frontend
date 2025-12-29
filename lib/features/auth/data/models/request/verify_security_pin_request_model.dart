class VerifySecurityPinRequestModel {
  const VerifySecurityPinRequestModel({
    required this.securityPin,
  });

  final int securityPin;

  Map<String, dynamic> toJson() {
    return {
      'security_pin': securityPin,
    };
  }
}
