/// Profile Module Configuration
///
/// This file contains configuration settings for the profile module,
/// including the ability to switch between mock data and real API calls.
class ProfileConfig {
  /// Set to true to use mock data instead of real API calls
  ///
  /// 🎭 MOCK MODE: Returns realistic mock data with simulated delays
  /// 🌐 API MODE: Makes real HTTP requests to the backend API
  ///
  /// Default: true (mock mode enabled for development)
  static const bool useMockData = false;

  /// Mock data delay in milliseconds
  ///
  /// Simulates network latency for more realistic testing
  static const int mockDelayMs = 800;

  /// Available mock user profiles
  ///
  /// Different user scenarios for comprehensive testing:
  /// - 'default': Regular active user with good stats
  /// - 'new': New user with minimal data
  /// - 'premium': High-value user with extensive history
  /// - 'problematic': User with account issues
  static const String defaultMockProfile = 'default';

  /// Debug logging for profile operations
  static const bool enableDebugLogging = true;

  /// Configuration summary
  static String get configSummary => '''
Profile Module Configuration:
├── Mock Data: ${useMockData ? 'ENABLED' : 'DISABLED'}
├── Mock Delay: ${mockDelayMs}ms
├── Default Profile: $defaultMockProfile
└── Debug Logging: ${enableDebugLogging ? 'ON' : 'OFF'}

${useMockData ? '🎭 Using mock data for development/testing' : '🌐 Using real API calls'}
''';
}
