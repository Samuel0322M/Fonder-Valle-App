import 'package:models/exceptions/app_exception.dart';

class ApiException extends AppException {
  final int? statusCode;
  final Map<String, dynamic>? response;
  ApiException({
    this.statusCode,
    this.response,
  });

  @override
  String toString() {
    var message = '$ApiException (';
    var messages = <String>[];
    if (statusCode != null) {
      messages.add('StatusCode: $statusCode');
    }
    if (response != null) {
      messages.add('Response: $response');
    }
    message += '${messages.join(" -- ")})';
    return message;
  }
}
