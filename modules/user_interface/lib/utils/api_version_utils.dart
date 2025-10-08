import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:user_interface/resources/values.dart';

class ApiVersionUtils {
  static Future<double> getPaddingFromApiVersion() async {
    double paddingMargin = 0.0;

    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 29) {
        paddingMargin = Values.paddingLong;
      }
    }

    return paddingMargin;
  }
}
