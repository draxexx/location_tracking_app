import 'package:flutter/material.dart';
import 'package:location_tracking_app/setup/app_initializer.dart';
import 'package:location_tracking_app/providers/place_provider.dart';
import 'package:location_tracking_app/providers/location_tracking_provider.dart';
import 'package:provider/provider.dart';

final class AppStateWrapper extends StatelessWidget {
  const AppStateWrapper({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationTrackingProvider>(
          create: (context) => getIt<LocationTrackingProvider>(),
        ),
        ChangeNotifierProvider<PlaceProvider>(
          create: (context) => getIt<PlaceProvider>(),
        ),
      ],
      child: child,
    );
  }
}
