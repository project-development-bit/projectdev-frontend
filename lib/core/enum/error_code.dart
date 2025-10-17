/// Error codes that can be returned from the API
enum ErrorCode {
  /// Account is not verified
  unverifiedAccount('UNVERIFIED_ACCOUNT');

  const ErrorCode(this.value);

  /// The string value of the error code
  final String value;

  /// Parse error code from string value
  static ErrorCode? fromString(String? value) {
    if (value == null) return null;
    
    for (ErrorCode code in ErrorCode.values) {
      if (code.value == value) {
        return code;
      }
    }
    return null;
  }

  /// Get the string representation
  @override
  String toString() => value;
}