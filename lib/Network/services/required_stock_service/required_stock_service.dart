import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/ResponseModel.dart';
import 'package:ftc_stocks/Network/api_base_helper.dart';

class RequiredStockService {
  ///Required Stock Service
  Future<ResponseModel> getRequiredStockService() async {
    final response = await ApiBaseHelper().getHTTP(
      ApiUrls.requiredStockApi,
      showProgress: false,
      onError: (error) {
        Utils.handleMessage(message: error.message);
      },
      onSuccess: (data) {
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          if (kDebugMode) {
            print("requiredStockApi success message :::: ${data.response?.data['msg']}");
          }
        } else {
          if (kDebugMode) {
            print("requiredStockApi error message :::: ${data.response?.data['msg']}");
          }
          Utils.handleMessage(message: data.response?.data['msg'], isError: true);
        }
      },
    );
    return response;
  }
}
