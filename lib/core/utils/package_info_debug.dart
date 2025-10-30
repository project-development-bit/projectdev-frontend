import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Debug utility to get and display package information
/// This helps verify the exact package name being sent to reCAPTCHA
class PackageInfoDebug {
  
  /// Get the Android package name using platform channels
  static Future<String?> getAndroidPackageName() async {
    try {
      if (!defaultTargetPlatform.name.toLowerCase().contains('android')) {
        debugPrint('📱 Not running on Android, package name check skipped');
        return null;
      }
      
      const platform = MethodChannel('flutter.io/packageInfo');
      final String? packageName = await platform.invokeMethod('getPackageName');
      
      debugPrint('📱 Android Package Name Debug:');
      debugPrint('   Package Name: $packageName');
      debugPrint('');
      debugPrint('🔧 Google Cloud Console Action Required:');
      debugPrint('   1. Go to: https://console.cloud.google.com/');
      debugPrint('   2. Navigate to: Security → reCAPTCHA Enterprise');
      debugPrint('   3. Find site key: 6LdjbvgrAAAAAINsAjihWllPukIAyNdXctSkNKo5');
      debugPrint('   4. Add Android package name: $packageName');
      debugPrint('');
      
      return packageName;
    } catch (e) {
      debugPrint('❌ Failed to get Android package name: $e');
      
      // Fallback - show expected package names based on build configuration
      debugPrint('📱 Expected Package Names (add ALL to Google Cloud Console):');
      debugPrint('   ✅ com.be.gigafaucet         (Production)');
      debugPrint('   ✅ com.be.gigafaucet.dev     (Development)');
      debugPrint('   ✅ com.be.gigafaucet.staging (Staging)');
      debugPrint('');
      debugPrint('🔧 Quick Fix: Add these 3 package names to your reCAPTCHA Enterprise site key');
      
      return null;
    }
  }
  
  /// Show the reCAPTCHA package name error solution
  static void showPackageNameSolution() {
    debugPrint('');
    debugPrint('🚨 reCAPTCHA "Package name not allowed" Error Solution:');
    debugPrint('');
    debugPrint('📋 Your Android Package Names:');
    debugPrint('   • com.be.gigafaucet         (Production flavor)');
    debugPrint('   • com.be.gigafaucet.dev     (Development flavor)');  
    debugPrint('   • com.be.gigafaucet.staging (Staging flavor)');
    debugPrint('');
    debugPrint('🔑 Your reCAPTCHA Site Key:');
    debugPrint('   • 6LdjbvgrAAAAAINsAjihWllPukIAyNdXctSkNKo5');
    debugPrint('');
    debugPrint('�️  Google Cloud Console Steps:');
    debugPrint('   1. Go to: https://console.cloud.google.com/');
    debugPrint('   2. Navigate to: Security → reCAPTCHA Enterprise');
    debugPrint('   3. Click on your site key: 6LdjbvgrAAAAAINsAjihWllPukIAyNdXctSkNKo5');
    debugPrint('   4. In "Android applications" section, add ALL 3 package names above');
    debugPrint('   5. Save the configuration');
    debugPrint('');
    debugPrint('✅ After adding package names, your reCAPTCHA will work correctly!');
    debugPrint('');
  }
}