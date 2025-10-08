import 'dart:developer';

import 'package:dio/dio.dart' as dio;

class AuthorizationInterceptor implements dio.Interceptor {
  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) async {
    try {
    } on dio.DioException catch (e) {
      return handler.reject(e);
    } catch (error) {
      log(error.toString(), name: 'error', error: error);
    }

    return handler.next(options);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
