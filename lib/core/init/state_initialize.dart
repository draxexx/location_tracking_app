import 'package:flutter/material.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/providers/location_provider.dart';
import 'package:location_tracking_app/providers/location_track_day_provider.dart';
import 'package:provider/provider.dart';

final class StateInitialize extends StatelessWidget {
  const StateInitialize({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationTrackDayProvider>(
          create: (context) => getIt<LocationTrackDayProvider>(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => getIt<LocationProvider>(),
        ),
      ],
      child: child,
    );
  }
}
