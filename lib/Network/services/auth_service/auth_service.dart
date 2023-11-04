import 'package:flutter/foundation.dart';
import 'package:ftc_stocks/Constants/api_keys.dart';
import 'package:ftc_stocks/Constants/api_urls.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Network/api_base_helper.dart';
import 'package:ftc_stocks/Network/models/auth_models/login_model.dart';

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
      showProgress: true,
      onError: (error) {
        Utils.validationCheck(message: error.message);
      },
      onSuccess: (data) {
        final loginModel = loginModelFromJson(data.response?.data);
        if (data.statusCode! >= 200 && data.statusCode! <= 299) {
          setData(AppConstance.authorizationToken, loginModel.token);
          if (kDebugMode) {
            print("login success message :::: ${loginModel.msg}");
          }
          Utils.validationCheck(message: loginModel.msg);
        } else {
          if (kDebugMode) {
            print("login error message :::: ${loginModel.msg}");
          }
          Utils.validationCheck(message: loginModel.msg, isError: true);
        }
      },
      params: param,
    );
    return response.statusCode! >= 200 && response.statusCode! <= 299;
  }
}
