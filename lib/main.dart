import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/init/state_initialize.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';
import 'package:location_tracking_app/screens/splash_screen.dart';

void main() async {
  runZonedGuarded(
    () async {
      // Initialize the dependencies
      await ApplicationInitialize().init();

      runApp(const MyApp());
    },
    (Object error, StackTrace stackTrace) {
      LogHelper.error('$error\n$stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StateInitialize(
      child: MaterialApp(
        title: 'Location Tracking App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
