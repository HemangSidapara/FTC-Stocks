import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_keys.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/ResponseModel.dart';
import 'package:ftc_stocks/Network/api_base_helper.dart';

class AddStockService {
  ///Get Stock Service
  Future<ResponseModel> getStockService() async {
    final response = await ApiBaseHelper().getHTTP(
      ApiUrls.getStockApi,
      showProgress: false,
      onError: (error) {
        Utils.validationCheck(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("getStockApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("getStockApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.validationCheck(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }

  ///Add Stock Service
  Future<ResponseModel> addStockService({
    required String productName,
    required String categoryName,
    required List<Map<String, String>> sizeData,
  }) async {
    var param = {
      ApiKeys.name: productName,
      ApiKeys.category: categoryName,
      ApiKeys.meta: sizeData,
    };
    final response = await ApiBaseHelper().postHTTP(
      ApiUrls.addStockApi,
      showProgress: false,
      onError: (error) {
        Utils.validationCheck(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("addStockApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("addStockApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.validationCheck(message: data.response?.data['msg'], isError: true);
        }
      },
      params: param,
    );
    return response;
  }
}
