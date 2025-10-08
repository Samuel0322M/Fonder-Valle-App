import 'dart:async';
import 'dart:developer';

import 'package:api_source/utils/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:models/exceptions/api_exception.dart';
import 'package:models/exceptions/cancel_connection_exception.dart';
import 'package:models/exceptions/connection_exception.dart';
import 'package:models/exceptions/app_exception.dart';
import 'package:models/exceptions/timeout_connection_exception.dart';

@lazySingleton
class ApiSource {
  final String authority;
  final Dio dio;

  ApiSource(
    @Named('authority') this.authority,
    this.dio,
  );

  Future<T> getApi<T>(
    String endpoint,
    T Function(dynamic value) mapperFunction, {
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final response = handleResponse(
      () => dio.get(
        endpoint,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      ),
      mapperFunction,
    );

    return response;
  }

  Future<T> postApi<T>(
    String endpoint,
    T Function(dynamic value) mapperFunction, {
    Options? options,
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancelToken,
  }) async {
    final response = handleResponse(
      () => dio.post(
        endpoint,
        options: options,
        queryParameters: queryParameters,
        data: data,
      ),
      mapperFunction,
    );

    return response;
  }

  Future<T> putApi<T>(
    String endpoint,
    T Function(dynamic value) mapperFunction, {
    Options? options,
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancelToken,
  }) async {
    final response = handleResponse(
      () => dio.put(
        endpoint,
        options: options,
        queryParameters: queryParameters,
        data: data,
        cancelToken: cancelToken,
      ),
      mapperFunction,
    );

    return response;
  }

  Future<T> multipartApi<T>(
    String endpoint,
    T Function(dynamic value) mapperFunction, {
    Options? options,
    Map<String, dynamic>? queryParameters,
    List<int>? bytes,
    String? fileName,
    required List<MapEntry<String, String>> fields,
    CancelToken? cancelToken,
  }) async {
    Map<String, dynamic> allData = {};
    fileName = fileName?.split('/').last;

    var formData = FormData.fromMap(allData);

    formData.fields.addAll(fields);

    final response = handleResponse(
      () => dio.post(
        endpoint,
        options: options,
        queryParameters: queryParameters,
        data: formData,
        cancelToken: cancelToken,
      ),
      mapperFunction,
    );

    return response;
  }

  Future<void> getFileBytes(
    String endpoint,
    Function(List<int>?) data, {
    Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await dio.get(
        endpoint,
        options: options ??
            Options(
              responseType: ResponseType.stream,
              receiveTimeout:
                  const Duration(minutes: ApiConstants.receiveTimeout),
            ),
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      response.data.stream.listen(
        (List<int> chunk) {
          data(chunk);
        },
        onError: (error) {
          data(null);
        },
        cancelOnError: true,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (error) {
      throw ApiException();
    }
  }

  Future<T> handleResponse<T>(Future<Response<dynamic>> Function() handler,
      T Function(dynamic value) mapperFunction) async {
    try {
      final response = await handler();
      return mapperFunction(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on ConnectionException {
      rethrow;
    } catch (error) {
      throw ApiException();
    }
  }

  AppException _handleDioError(DioException error) {
    log(error.runtimeType.toString());

    switch (error.type) {
      case DioExceptionType.connectionError:
        throw ConnectionException();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutConnectionException();
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        throw ApiException(
            statusCode: error.response?.statusCode,
            response: error.response?.data);
      case DioExceptionType.cancel:
        throw CancelConnectionException();
      default:
        throw AppException();
    }
  }
}