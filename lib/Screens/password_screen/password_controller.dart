import 'package:flutter/cupertino.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Network/services/auth_service/auth_service.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class PasswordController extends GetxController {
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
    final isValid = passwordFormKey.currentState!.validate();
    if (!isValid) {
    } else {
      final isSuccess = await AuthService().loginService(
        phone: Get.arguments,
        password: passwordController.text,
      );
      if (isSuccess) {
        await Get.offAllNamed(Routes.homeScreen);
      }
    }
  }
}
