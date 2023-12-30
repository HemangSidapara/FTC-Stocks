import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_keys.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Network/api_base_helper.dart';
import 'package:ftc_stocks/Network/models/auth_models/login_model.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:get/get.dart';

class AuthService {
  ///login Service
  Future<bool> loginService({
    required String phone,
    required String password,
  }) async {
    var param = {
      ApiKeys.phone: phone,
      ApiKeys.password: password,
    };
    var response = await ApiBaseHelper().postHTTP(
      ApiUrls.loginApi,
      showProgress: false,
      onError: (error) {
        Utils.validationCheck(message: error.message);
      },
      onSuccess: (data) {
        final loginModel = loginModelFromJson(jsonEncode(data.response!.data));
        if (data.isSuccess && loginModel.code!.toInt() >= 200 && loginModel.code!.toInt() <= 299) {
          setData(AppConstance.authorizationToken, loginModel.token);
          if (kDebugMode) {
            print("login success message :::: ${loginModel.msg}");
          }
          Utils.validationCheck(message: loginModel.msg?.tr);
        } else {
          if (kDebugMode) {
            print("login error message :::: ${loginModel.msg}");
          }
          Utils.validationCheck(message: loginModel.msg?.tr, isError: true);
        }
      },
      params: param,
    );
    return response.isSuccess;
  }
}
