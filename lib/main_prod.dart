import 'package:flutter/material.dart';
import 'main_common.dart';
import 'core/config/app_flavor.dart';
import 'core/config/flavor_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize production flavor
  FlavorManager.initialize(AppFlavor.prod);

  // Run the common app initialization
  await runAppWithFlavor(AppFlavor.prod);
}
