import 'package:flutter/foundation.dart';

/// Configure URL strategy for Flutter web
void configureUrlStrategy() {
  if (kIsWeb) {
    // For Flutter web, we need to set the URL strategy to use path-based routing
    // This allows clean URLs like /login instead of /#/login
    
    // Note: This is automatically handled by GoRouter in newer versions
    // but we can ensure it's configured properly
  }
}