import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    Future.delayed(
      const Duration(seconds: 3),
      () async {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: AppColors.WHITE_COLOR, systemNavigationBarIconBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark, statusBarColor: AppColors.TRANSPARENT, statusBarBrightness: Brightness.light));
        if (kDebugMode) {
          print("token value ::: ${getData(AppConstance.authorizationToken)}");
        }
        if (getData(AppConstance.authorizationToken) == null) {
          Get.offAllNamed(Routes.welcomeScreen);
        } else {
          Get.offAllNamed(Routes.homeScreen);
        }
      },
    );
  }
}
