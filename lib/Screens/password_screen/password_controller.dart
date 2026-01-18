import 'package:flutter/cupertino.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/services/auth_services/auth_services.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
  RxBool isSignInLoading = false.obs;

  GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  RxBool isShowPassword = false.obs;

  String? validatePassword(String value) {
    if (value.isEmpty == true) {
      return AppStrings.pleaseEnterPassword.tr;
    }
    return null;
  }

  Future<void> checkPassword() async {
    Utils.unfocus();
    final isValid = passwordFormKey.currentState?.validate() ?? false;
    if (isValid) {
      try {
        isSignInLoading(true);
        final isSuccess = await AuthServices.loginService(
          phone: Get.arguments,
          password: passwordController.text,
        );
        if (isSuccess) {
          await Get.offAllNamed(Routes.homeScreen);
        }
      } finally {
        isSignInLoading(false);
      }
    }
  }
}
