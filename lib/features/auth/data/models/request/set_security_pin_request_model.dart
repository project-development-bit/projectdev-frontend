/// Set Security Pin Request Model
///
/// Represents the request body for `POST /users/security-pin`
class SetSecurityPinRequestModel {
  const SetSecurityPinRequestModel({
    required this.securityPin,
    required this.enable,
  });

  final int securityPin;
  final bool enable;

  Map<String, dynamic> toJson() {
    return {
      'security_pin': securityPin,
      'enable': enable,
    };
  }
}
