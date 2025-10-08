import 'package:rxdart/rxdart.dart';

extension BehaviorSubjectExtension<T> on BehaviorSubject<T> {
  void addSecure(T event) {
    if (!isClosed) {
      add(event);
    }
  }

  void addErrorSecure(Object error, [StackTrace? stackTrace]) {
    if (!isClosed) {
      addError(error, stackTrace);
    }
  }
}
