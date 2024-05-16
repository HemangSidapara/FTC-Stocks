import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/ResponseModel.dart';
import 'package:ftc_stocks/Network/api_base_helper.dart';

class ChallanService {
  Future<ResponseModel> getCompletedOrdersService() async {
    final response = await ApiBaseHelper().getHTTP(
      "${ApiUrls.getOrdersApi}&status=1",
      showProgress: false,
      onError: (dioExceptions) {
        Utils.handleMessage(message: dioExceptions.message, isError: true);
      },
      onSuccess: (res) {
        if (res.isSuccess) {
          debugPrint("getCompletedOrderApi success :: ${res.message}");
        } else {
          debugPrint("getCompletedOrderApi error :: ${res.message}");
          Utils.handleMessage(message: res.message, isError: true);
        }
      },
    );
    return response;
  }
}
