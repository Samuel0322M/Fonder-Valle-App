import 'package:data/base/api_source.dart';
import 'package:dio/dio.dart';

mixin CancelRequestMixin implements CancelRequestApiSource {
  CancelToken? _cancelToken;
  CancelToken? get cancelToken => _cancelToken;

  void createCancelToken() {
    if (_cancelToken == null || _cancelToken!.isCancelled) {
      _cancelToken = CancelToken();
    }
  }

  @override
  void cancelRequest() {
    if (_cancelToken == null) {
      return;
    }

    if (!_cancelToken!.isCancelled) {
      _cancelToken!.cancel();

      _cancelToken = null;
    }
  }
}

mixin CancelRequestsMixin implements CancelRequestByIdApiSource {
  Map<String, CancelToken?>? _cancelTokens;

  CancelToken addCancelToken(String id) {
    _cancelTokens ??= {};
    if (!_cancelTokens!.containsKey(id) ||
        _cancelTokens![id] == null ||
        _cancelTokens![id]!.isCancelled) {
      _cancelTokens![id] = CancelToken();
    }
    return _cancelTokens![id]!;
  }

  @override
  void cancelRequest(String id) {
    final cancelToken = _cancelTokens?[id];
    if (cancelToken == null) {
      return;
    }

    if (!cancelToken.isCancelled) {
      _cancelTokens?[id]?.cancel();
      _cancelTokens?[id] = null;
    }
  }
}
