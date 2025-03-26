import 'package:flutter/material.dart';
import 'package:location_tracking_app/setup/application_initializer.dart';
import 'package:location_tracking_app/utils/helpers/log_helper.dart';
import 'package:location_tracking_app/providers/place_provider.dart';
import 'package:location_tracking_app/providers/location_tracking_provider.dart';
import 'package:location_tracking_app/screens/main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _redirectToMain() {
    if (mounted) {
      Navigator.pushReplacement(context, MainScreen.route());
    }
  }

  Future<void> _initializePlaces() async {
    final placeProvider = getIt<PlaceProvider>();
    await placeProvider.loadPlaces();
    await placeProvider.ensureTravelPlaceExists();
  }

  Future<void> _initializeTrackedLocationEntries() async {
    await getIt<LocationTrackingProvider>().initializeTrackedLocationEntries();
  }

  Future<void> _initialize() async {
    try {
      await _initializePlaces();
      await _initializeTrackedLocationEntries();

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
