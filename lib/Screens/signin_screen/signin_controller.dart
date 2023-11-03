import 'package:flutter/cupertino.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();

  String? validatePhoneNumber(String value) {
    if (value.isEmpty == true) {
      return AppStrings.pleaseEnterPhoneNumber.tr;
    } else if (!GetUtils.isPhoneNumber(value)) {
      return AppStrings.pleaseEnterValidPhoneNumber.tr;
    }
    return null;
  }

  Future<void> checkLogin() async {
    final isValid = signInFormKey.currentState!.validate();
    if (!isValid) {
    } else {
      Get.toNamed(Routes.passwordScreen);
    }
  }
}
