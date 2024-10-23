
import 'dart:io' as io; // Import this to check platform
import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = '';

  if (io.Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id.toString(); // Unique ID for Android
  } else if (io.Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor.toString(); // Unique ID for iOS
  }

  return deviceId;
}
