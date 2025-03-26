import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracking_app/setup/hive_setup.dart';
import 'package:location_tracking_app/setup/service_locator.dart';
import 'package:location_tracking_app/setup/system_config.dart';
import 'package:location_tracking_app/utils/helpers/log_helper.dart';

final getIt = GetIt.instance;

final class AppInitializer {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await setupHive();
      setupLocator();
      setSystemConfigurations();
    } catch (e) {
      LogHelper.error("Initialization failed: $e");
    }

    // Log Flutter Errors
    FlutterError.onError = (details) {
      /// crashlytics log insert here
      /// custom service or custom logger insert here
      LogHelper.error(details.exceptionAsString());
      FlutterError.presentError(details);
    };
  }
}
