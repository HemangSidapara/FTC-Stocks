
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Utils/progress_dialog.dart';
import 'package:ftc_stocks/Utils/utils.dart';

import 'ResponseModel.dart';

class ApiBaseHelper {
  static const String baseUrl = ApiUrls.baseUrl;
  static bool showProgressDialog = true;

  static BaseOptions opts = BaseOptions(
    baseUrl: baseUrl,
    responseType: ResponseType.json,
    connectTimeout: 45000,
    receiveTimeout: 45000,
    sendTimeout: 45000,
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    ///For Print Logs
    if (!kReleaseMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          error: true,
          responseHeader: true,
        ),
      );
    }

    ///For Show Hide Progress Dialog
    return dio
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) {
            if (showProgressDialog) ProgressDialog.showProgressDialog(true);
            Logger.printLog(tag: '|---------------> ${options.method} JSON METHOD <---------------|\n\n REQUEST_URL :', printLog: '\n ${options.uri} \n\n REQUEST_HEADER : ${options.headers}  \n\n REQUEST_DATA : ${options.data.toString()}', logIcon: Logger.info);
            requestInterceptor(options, handler);
          },
          onResponse: (response, handler) {
            ProgressDialog.showProgressDialog(false);
            showProgressDialog = true;

            if (response.statusCode! >= 100 && response.statusCode! <= 199) {
              Logger.printLog(tag: 'WARNING CODE ${response.statusCode} : ', printLog: response.data.toString(), logIcon: Logger.warning);
            } else {
              Logger.printLog(tag: 'SUCCESS CODE ${response.statusCode} : ', printLog: response.data.toString(), logIcon: Logger.success);
            }

            /// change after upgrade
            return handler.next(response);
          },
          onError: (DioError e, handler) async {
            ProgressDialog.showProgressDialog(false);
            showProgressDialog = true;

            Logger.printLog(tag: 'ERROR CODE ${e.response?.statusCode} : ', printLog: e.toString(), logIcon: Logger.error);

            return handler.next(e);
          },
        ),
      );
  }

  static dynamic requestInterceptor(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get your JWT token

    options.headers.addAll({"Authorization": "Bearer ${getData(AppConstance.authorizationToken)}"});

    return handler.next(options);
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);

  Future<ResponseModel> postHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      showProgressDialog = showProgress;
      Response response = await baseAPI.post(
        url,
        data: params,
        onSendProgress: onSendProgress,
      );
      return handleResponse(response, onError!, onSuccess!);
    } on DioError catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  Future<ResponseModel> deleteHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
  }) async {
    try {
      showProgressDialog = showProgress;
      Response response = await baseAPI.delete(
        url,
        data: params,
      );
      return handleResponse(response, onError!, onSuccess!);
    } on DioError catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  Future<ResponseModel> getHTTP(
    String url, {
    dynamic params,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
  }) async {
    try {
      showProgressDialog = showProgress;
      Response response = await baseAPI.get(url, queryParameters: params);

      return handleResponse(response, onError!, onSuccess!);
    } on DioError catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  Future<ResponseModel> putHTTP(
    String url, {
    dynamic data,
    bool showProgress = true,
    Function(ResponseModel res)? onSuccess,
    Function(DioExceptions dioExceptions)? onError,
  }) async {
    try {
      showProgressDialog = showProgress;
      Response response = await baseAPI.put(url, data: data);
      return handleResponse(response, onError!, onSuccess!);
    } on DioError catch (e) {
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
  }) async {
    try {
      showProgressDialog = showProgress;
      Response response = await baseAPI.patch(
        url,
        data: params,
        onSendProgress: onSendProgress,
      );
      return handleResponse(response, onError!, onSuccess!);
    } on DioError catch (e) {
      return handleError(e, onError!, onSuccess!);
    }
  }

  handleResponse(
    Response response,
    Function(DioExceptions dioExceptions) onError,
    Function(ResponseModel res) onSuccess,
  ) {
    var successModel = ResponseModel(statusCode: response.statusCode, response: response);
    onSuccess(successModel);
    return successModel;
  }

  static handleError(
    DioError e,
    Function(DioExceptions dioExceptions) onError,
    Function(ResponseModel res) onSuccess,
  ) {
    switch (e.type) {
      case DioErrorType.response:
        var errorModel = ResponseModel(statusCode: e.response!.statusCode, response: e.response);
        onSuccess(errorModel);
        return ResponseModel(statusCode: e.response!.statusCode, response: e.response);
      default:
        onError(DioExceptions.fromDioError(e));
        throw DioExceptions.fromDioError(e).message!;
    }
  }

// static NetworkExceptions getDioException(error) {
//   if (error is Exception) {
//     try {
//       NetworkExceptions networkExceptions;
//       if (error is DioError) {
//         switch (error.type) {
//           case DioErrorType.CANCEL:
//             networkExceptions = NetworkExceptions.requestCancelled();
//             break;
//           case DioErrorType.CONNECT_TIMEOUT:
//             networkExceptions = NetworkExceptions.requestTimeout();
//             break;
//           case DioErrorType.DEFAULT:
//             networkExceptions = NetworkExceptions.noInternetConnection();
//             break;
//           case DioErrorType.RECEIVE_TIMEOUT:
//             networkExceptions = NetworkExceptions.sendTimeout();
//             break;
//           case DioErrorType.RESPONSE:
//             switch (error.response.statusCode) {
//               case 400:
//                 networkExceptions = NetworkExceptions.unauthorisedRequest();
//                 break;
//               case 401:
//                 networkExceptions = NetworkExceptions.unauthorisedRequest();
//                 break;
//               case 403:
//                 networkExceptions = NetworkExceptions.unauthorisedRequest();
//                 break;
//               case 404:
//                 networkExceptions = NetworkExceptions.notFound("Not found");
//                 break;
//               case 409:
//                 networkExceptions = NetworkExceptions.conflict();
//                 break;
//               case 408:
//                 networkExceptions = NetworkExceptions.requestTimeout();
//                 break;
//               case 500:
//                 networkExceptions = NetworkExceptions.internalServerError();
//                 break;
//               case 503:
//                 networkExceptions = NetworkExceptions.serviceUnavailable();
//                 break;
//               default:
//                 var responseCode = error.response.statusCode;
//                 networkExceptions = NetworkExceptions.defaultError(
//                   "Received invalid status code: $responseCode",
//                 );
//             }
//             break;
//           case DioErrorType.SEND_TIMEOUT:
//             networkExceptions = NetworkExceptions.sendTimeout();
//             break;
//         }
//       } else if (error is SocketException) {
//         networkExceptions = NetworkExceptions.noInternetConnection();
//       } else {
//         networkExceptions = NetworkExceptions.unexpectedError();
//       }
//       return networkExceptions;
//     } on FormatException catch (e) {
//       // Helper.printError(e.toString());
//       return NetworkExceptions.formatException();
//     } catch (_) {
//       return NetworkExceptions.unexpectedError();
//     }
//   } else {
//     if (error.toString().contains("is not a subtype of")) {
//       return NetworkExceptions.unableToProcess();
//     } else {
//       return NetworkExceptions.unexpectedError();
//     }
//   }
// }
}

class DioExceptions implements Exception {
  String? message;

  DioExceptions.fromDioError(DioError? dioError) {
    switch (dioError!.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.other:
        message = "No internet connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        message = _handleResponseError(dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioErrorType.sendTimeout:
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
