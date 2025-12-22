import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'main_common.dart';
import 'core/config/app_flavor.dart';
import 'core/config/flavor_manager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize production flavor
  FlavorManager.initialize(AppFlavor.prod);

  // Run the common app initialization
  await runAppWithFlavor(AppFlavor.prod);
}
