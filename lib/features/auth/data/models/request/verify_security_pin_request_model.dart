class VerifySecurityPinRequestModel {
  const VerifySecurityPinRequestModel({
    required this.securityPin,
  });

  final String securityPin;

  Map<String, dynamic> toJson() {
    return {
      'security_pin': securityPin,
    };
  }
}
