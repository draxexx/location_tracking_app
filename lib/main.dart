import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/init/state_initialize.dart';
import 'package:location_tracking_app/screens/main_screen/main_screen.dart';

void main() async {
  await ApplicationInitialize().init();

  runApp(const MyApp());
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
        home: const MainScreen(),
      ),
    );
  }
}
