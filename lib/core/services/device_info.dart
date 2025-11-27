import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unique_device_identifier/unique_device_identifier.dart';

final deviceInfoProvider = Provider<DeviceInfo>(
  (ref) => DeviceInfo(),
);

class DeviceInfo {
  Future<String> getUserAgent() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    final appName = packageInfo.appName;
    final appVersion = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;

    if (kIsWeb) {
      // Real browser UA for web
      final webInfo = await deviceInfo.webBrowserInfo;
      final ua = webInfo.userAgent ?? '';
      if (ua.isNotEmpty) {
        return ua;
      }
      // fallback if somehow null
      return '$appName/$appVersion (Web)';
    }

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final osVersion = androidInfo.version.release;
      final manufacturer = androidInfo.manufacturer;
      final model = androidInfo.model;

      // Example: Gigafaucet/1.0.3 (Android 14; Google Pixel 7; build 123)
      return '$appName/$appVersion+$buildNumber '
          '(Android $osVersion; $manufacturer $model)';
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      final systemName = iosInfo.systemName;
      final systemVersion = iosInfo.systemVersion;
      final model = iosInfo.utsname.machine;

      // Example: Gigafaucet/1.0.3 (iOS 17.1; iPhone15,2)
      return '$appName/$appVersion+$buildNumber '
          '($systemName $systemVersion; $model)';
    }

    // Optional: handle other platforms if you care
    return '$appName/$appVersion+$buildNumber (Unknown Platform)';
  }

  Future<String?> getUniqueIdentifier() async {
    final String? deviceId = await UniqueDeviceIdentifier.getUniqueIdentifier();
    debugPrint("UniqueDeviceIdentifier device_fingerprint: $deviceId");
    return deviceId;
  }
}
