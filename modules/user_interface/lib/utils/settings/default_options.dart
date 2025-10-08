import 'package:intl/intl.dart';

class DefaultOptions {
  static const Duration requestTimeout = Duration(seconds: 30);
  static DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  static DateFormat dateFormatHistory = DateFormat("yyyy-MM-ddTHH:mm:ss");
}
