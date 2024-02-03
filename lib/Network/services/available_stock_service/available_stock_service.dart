import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/ResponseModel.dart';
import 'package:ftc_stocks/Network/api_base_helper.dart';

class AvailableStockService {
  ///Available Stock Service
  Future<ResponseModel> getAvailableStockService() async {
    final response = await ApiBaseHelper().getHTTP(
      ApiUrls.availableStockApi,
      showProgress: false,
      onError: (error) {
        Utils.handleMessage(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("availableStockApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("availableStockApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.handleMessage(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }
}
