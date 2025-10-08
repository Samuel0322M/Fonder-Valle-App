import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:user_interface/utils/settings/default_options.dart';

extension DateTimeExtension on DateTime {
  Future<String?> getCurrentTimeZone() async {
    return await FlutterTimezone.getLocalTimezone();
  }

  String getFormatDate() {
    return DefaultOptions.dateFormat.format(this);
  }

  String toHistoryFormat() {
    return DefaultOptions.dateFormatHistory.format(this);
  }
}
