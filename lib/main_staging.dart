import 'package:flutter/material.dart';
import 'main_common.dart';
import 'core/config/app_flavor.dart';
import 'core/config/flavor_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize staging flavor
  FlavorManager.initialize(AppFlavor.staging);

  // Run the common app initialization
  await runAppWithFlavor(AppFlavor.staging);
}
