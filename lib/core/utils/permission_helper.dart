import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/init/application_initialize.dart';
import 'package:location_tracking_app/core/utils/consts/enums/location_permission_status.dart';
import 'package:location_tracking_app/core/widgets/confirm_dialog.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';

final class PermissionHelper {
  static Future<bool> checkAndRequestPermission({
    required BuildContext context,
    required LocationPermissionStatus permissionStatus,
  }) async {
    final geolocatorService = getIt<GeolocatorService>();

    if (permissionStatus == LocationPermissionStatus.serviceDisabled) {
      showConfirmDialog(
        context: context,
        onSubmit: () => geolocatorService.openSettings(),
        message: "Please enable location service to continue.",
      );
      return false;
    } else if (permissionStatus == LocationPermissionStatus.denied) {
      showConfirmDialog(
        context: context,
        onSubmit: () => geolocatorService.openSettings(),
        message: "Please enable location permission to continue.",
      );
      return false;
    } else if (permissionStatus == LocationPermissionStatus.deniedForever) {
      showConfirmDialog(
        context: context,
        onSubmit: () => geolocatorService.openSettings(),
        message: "Please enable location permission to continue.",
      );
      return false;
    } else if (permissionStatus == LocationPermissionStatus.grantedWhileInUse) {
      if (Platform.isAndroid) {
        final permission = await geolocatorService.requestPermission();

        if (permission == LocationPermission.whileInUse && context.mounted) {
          showConfirmDialog(
            context: context,
            onSubmit: () => geolocatorService.openSettings(),
            message:
                "Please enable location permission as 'Always' to continue.",
          );
        }
      } else if (Platform.isIOS) {
        showConfirmDialog(
          context: context,
          onSubmit: () => geolocatorService.openSettings(),
          message: "Please enable location permission as 'Always' to continue.",
        );
      }
      return false;
    } else if (permissionStatus == LocationPermissionStatus.grantedAlways) {
      return true;
    }

    return true;
  }
}
