import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_keys.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/ResponseModel.dart';
import 'package:ftc_stocks/Network/api_base_helper.dart';

class CreateOrderService {
  ///Get Orders Service
  Future<ResponseModel> getOrdersService({bool isPending = true}) async {
    final response = await ApiBaseHelper().getHTTP(
      '${ApiUrls.getOrdersApi}&status=${isPending ? 0 : 1}',
      showProgress: false,
      onError: (error) {
        Utils.handleMessage(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("getOrdersApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("getOrdersApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.handleMessage(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }

  ///Create Order Service
  Future<ResponseModel> createOrdersService({
    required String partyName,
    required String phone,
    required String modelId,
    required List<Map<String, String>> orderData,
  }) async {
    final params = {
      ApiKeys.partyName: partyName,
      ApiKeys.phone: phone,
      ApiKeys.modelID: modelId,
      ApiKeys.meta: orderData,
    };

    final response = await ApiBaseHelper().postHTTP(
      ApiUrls.createOrderApi,
      showProgress: false,
      params: params,
      onError: (error) {
        Utils.handleMessage(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("createOrderApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("createOrderApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.handleMessage(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }

  ///Cancel Order Service
  Future<ResponseModel> cancelOrdersService({required String metaId}) async {
    final params = {
      ApiKeys.metaID: metaId,
    };

    final response = await ApiBaseHelper().postHTTP(
      ApiUrls.cancelOrderApi,
      showProgress: false,
      params: params,
      onError: (error) {
        Utils.handleMessage(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("cancelOrderApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("cancelOrderApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.handleMessage(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }

  ///Complete Order Service
  Future<ResponseModel> completeOrdersService({required String orderId}) async {
    final params = {
      ApiKeys.orderID: orderId,
    };

    final response = await ApiBaseHelper().postHTTP(
      ApiUrls.completeOrderApi,
      showProgress: false,
      params: params,
      onError: (error) {
        Utils.handleMessage(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("completeOrderApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("completeOrderApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.handleMessage(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }

  ///Get Parties Service
  Future<ResponseModel> getPartiesService({bool isPending = true}) async {
    final response = await ApiBaseHelper().getHTTP(
      ApiUrls.getPartiesApi,
      showProgress: false,
      onError: (error) {
        Utils.handleMessage(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("getPartiesApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("getPartiesApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.handleMessage(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }
}
