import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracking_app/core/utils/consts/enums/location_permission_status.dart';
import 'package:location_tracking_app/core/utils/log_helper.dart';
import 'package:location_tracking_app/core/widgets/confirm_dialog.dart';
import 'package:location_tracking_app/services/geolocator_service.dart';

/// The helper class for checking and requesting location permission
final class PermissionHelper {
  static Future<bool> checkAndRequestPermission({
    required BuildContext context,
    required LocationPermissionStatus permissionStatus,
    required GeolocatorService geolocatorService,
  }) async {
    try {
      if (permissionStatus == LocationPermissionStatus.serviceDisabled) {
        _showConfirmDialog(
          context,
          geolocatorService,
          "Please enable location service to continue.",
        );
        return false;
      } else if (permissionStatus == LocationPermissionStatus.denied) {
        _showConfirmDialog(
          context,
          geolocatorService,
          "Please enable location permission to continue.",
        );
        return false;
      } else if (permissionStatus == LocationPermissionStatus.deniedForever) {
        _showConfirmDialog(
          context,
          geolocatorService,
          "Please enable location permission to continue.",
        );
        return false;
      } else if (permissionStatus ==
          LocationPermissionStatus.grantedWhileInUse) {
        if (Platform.isAndroid) {
          final permission = await geolocatorService.requestPermission();

          if (permission == LocationPermission.whileInUse && context.mounted) {
            _showConfirmDialog(
              context,
              geolocatorService,
              "Please enable location permission as 'Always' to get your location on background.",
            );
          }
        } else if (Platform.isIOS) {
          _showConfirmDialog(
            context,
            geolocatorService,
            "Please enable location permission as 'Always' to get your location on background.",
          );
        }
        return false;
      } else if (permissionStatus == LocationPermissionStatus.grantedAlways) {
        return true;
      }

      return true;
    } catch (e) {
      LogHelper.error("Error in checkAndRequestPermission: $e");
      return false;
    }
  }

  static void _showConfirmDialog(
    BuildContext context,
    GeolocatorService geolocatorService,
    String message,
  ) {
    showConfirmDialog(
      context: context,
      onSubmit: () => geolocatorService.openSettings(),
      message: message,
    );
  }
}
