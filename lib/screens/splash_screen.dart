import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';
import 'package:location_tracking_app/providers/place_provider.dart';
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

  // This method is used to initialize the places
  Future<void> _initializePlaces() async {
    final placeProvider = getIt<PlaceProvider>();
    await placeProvider.loadPlaces();
    await placeProvider.ensureTravelPlaceExists();
  }

  // This method is used to initialize the daily place entry
  Future<void> _initializeDailyPlaceEntry() async {
    await getIt<DailyPlaceEntryProvider>().initializeDailyPlaceEntry();
  }

  // This method is used to initialize data
  Future<void> _initialize() async {
    try {
      await _initializePlaces();
      await _initializeDailyPlaceEntry();

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
