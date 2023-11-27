import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsUtil {
  static Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        // Permission granted
        if (kDebugMode) {
          print("Location permission granted");
        }
      }
    }

    if (status.isPermanentlyDenied) {
      // The user opted not to grant permission and should be directed to the settings
      openAppSettings();
    }
  }
}
