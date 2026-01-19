import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Utils/progress_dialog.dart';
import 'package:ftc_stocks/Utils/utils.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'ResponseModel.dart';

class ApiBaseHelper {
  static bool showProgressDialog = true;
  static Stopwatch stopWatch = Stopwatch();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.baseUrl,
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 45),
        sendTimeout: const Duration(seconds: 45),
      ),
    );

    return _addInterceptors(dio);
  }

  static Dio _addInterceptors(Dio dio) {
    ///For Print Logs
    dio.interceptors.add(
      PrettyDioLogger(
        responseHeader: true,
        requestBody: true,
        maxWidth: 500,
        enabled: kDebugMode,
      ),
    );

    ///For Show Hide Progress Dialog
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) async {
            return requestInterceptor(options, handler);
          },
          onResponse: (response, handler) async {
            return handler.next(response);
          },
          onError: (DioException e, handler) async {
            return handler.next(e);
          },
        ),
      );
  }

  static dynamic requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) async {
    return handler.next(options);
  }

  static Future<void> showOrRemoveProgressFunction({required bool showProgress, bool isRemove = false}) async {
    if (showProgress && Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    if (showProgress) Get.put(ProgressDialog()).showProgressDialog(!isRemove);
    if (showProgress && isRemove) Get.delete<ProgressDialog>();
  }

  static Options getOptions({Options? options}) {
    Options newOptions = options ?? Options();
    final headers = newOptions.headers ?? {};
    headers.putIfAbsent("Authorization", () => "Bearer ${getData(AppConstance.authorizationToken)}");
    headers.putIfAbsent("content-type", () => "application/json");
    return newOptions.copyWith(headers: headers);
  }

  Future<ResponseModel> postHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    void Function(int, int)? onSendProgress,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      await showOrRemoveProgressFunction(showProgress: showProgress);
      final baseAPI = _createDio();
      Response response = await baseAPI.post(
        url,
        data: params,
        onSendProgress: onSendProgress,
        options: getOptions(options: options),
      );
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      stopWatch.reset();
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      return handleError(e, onError!, onSuccess!);
    }
  }

  Future<ResponseModel> deleteHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      await showOrRemoveProgressFunction(showProgress: showProgress);
      final baseAPI = _createDio();
      Response response = await baseAPI.delete(
        url,
        data: params,
        cancelToken: cancelToken,
        options: getOptions(options: options),
      );
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      stopWatch.reset();
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      return handleError(e, onError!, onSuccess!);
    }
  }

  Future<ResponseModel> getHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      await showOrRemoveProgressFunction(showProgress: showProgress);
      final baseAPI = _createDio();
      Response response = await baseAPI.get(
        url,
        queryParameters: params,
        cancelToken: cancelToken,
        options: getOptions(options: options),
      );
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      stopWatch.reset();
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      return handleError(e, onError!, onSuccess!);
    }
  }

  Future<ResponseModel> putHTTP(
    String url, {
    dynamic data,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      await showOrRemoveProgressFunction(showProgress: showProgress);
      final baseAPI = _createDio();
      Response response = await baseAPI.put(
        url,
        data: data,
        options: getOptions(options: options),
      );
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      stopWatch.reset();
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      return handleError(e, onError!, onSuccess!);
    }
  }

  Future<ResponseModel> patchHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    void Function(int count, int total)? onSendProgress,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      showProgressDialog = showProgress;
      stopWatch.start();
      await showOrRemoveProgressFunction(showProgress: showProgress);
      final baseAPI = _createDio();
      Response response = await baseAPI.patch(
        url,
        data: params,
        onSendProgress: onSendProgress,
        options: getOptions(options: options),
      );
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      stopWatch.stop();
      Logger.printLog(isTimer: true, printLog: stopWatch.elapsed.inMilliseconds / 1000);
      stopWatch.reset();
      return handleResponse(response, onError!, onSuccess!);
    } on DioException catch (e) {
      await showOrRemoveProgressFunction(showProgress: showProgress, isRemove: true);
      return handleError(e, onError!, onSuccess!);
    }
  }

  static ResponseModel handleResponse(
    Response response,
    Function(DioExceptions dioExceptions) onError,
    Function(ResponseModel res) onSuccess,
  ) {
    var successModel = ResponseModel(statusCode: response.statusCode, response: response);
    onSuccess(successModel);
    return successModel;
  }

  static ResponseModel handleError(
    DioException e,
    Function(DioExceptions dioExceptions) onError,
    Function(ResponseModel res) onSuccess,
  ) {
    switch (e.type) {
      case DioExceptionType.badResponse:
        var errorModel = ResponseModel(statusCode: e.response!.statusCode, response: e.response);
        onSuccess(errorModel);
        return ResponseModel(statusCode: e.response!.statusCode, response: e.response);
      default:
        onError(DioExceptions.fromDioError(e));
        Utils.handleMessage(message: DioExceptions.fromDioError(e).message, isError: true);
        return ResponseModel(statusCode: e.response?.statusCode, response: e.response);
    }
  }
}

class DioExceptions implements Exception {
  String? message;
  int? statusCode;

  DioExceptions.fromDioError(DioException? dioError) {
    statusCode = dioError?.response?.statusCode;
    switch (dioError!.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.unknown:
        message = "No internet connection";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleResponseError(dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleResponseError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error["message"];
      case 500:
        return 'Internal Server Error. Please try again.';
      default:
        return 'Sorry, something went wrong. Please try again.';
    }
  }
}
