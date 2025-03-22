import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';
import 'package:location_tracking_app/providers/location_provider.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:location_tracking_app/screens/main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // This method is used to redirect to the main screen
  void _redirectToMain() {
    if (mounted) {
      Navigator.pushReplacement(context, MainScreen.route());
    }
  }

  // This method is used to initialize the locations
  Future<void> _initializeLocations() async {
    final locationProvider = getIt<LocationProvider>();
    await locationProvider.loadLocations();
    await locationProvider.ensureTravelLocationExists();
  }

  // This method is used to initialize the location track day
  Future<void> _initializeLocationTrackDay() async {
    await getIt<LocationTrackDayProvider>().initializeLocationTrackDay();
  }

  // This method is used to initialize data
  Future<void> _initialize() async {
    try {
      await _initializeLocations();
      await _initializeLocationTrackDay();

      _redirectToMain();
    } catch (e, stack) {
      LogHelper.error('$e\n$stack');
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            "LOCATION TRACKING APP",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
