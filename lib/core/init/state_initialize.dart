import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/providers/place_provider.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:provider/provider.dart';

final class StateInitialize extends StatelessWidget {
  const StateInitialize({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DailyPlaceEntryProvider>(
          create: (context) => getIt<DailyPlaceEntryProvider>(),
        ),
        ChangeNotifierProvider<PlaceProvider>(
          create: (context) => getIt<PlaceProvider>(),
        ),
      ],
      child: child,
    );
  }
}
