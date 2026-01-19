import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Screens/home_screen/home_controller.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app_strings.dart';

class Utils {
  static String _appVersion = "";

  static HomeController get getHomeController => Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

  static Future<String> setAppVersion() async {
    final pkgInfo = await PackageInfo.fromPlatform();
    _appVersion = "v${pkgInfo.version}.${pkgInfo.buildNumber}";
    return _appVersion;
  }

  static String get appVersion => _appVersion;

  ///Unfocus
  static void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  ///Current app is latest or not
  static bool isUpdateAvailable(String currentVersion, String newAPKVersion) {
    List<String> versionNumberList = currentVersion.split('.').toList();
    List<String> storeVersionNumberList = newAPKVersion.split('.').toList();
    for (int i = 0; i < versionNumberList.length; i++) {
      if (versionNumberList[i].toInt() != storeVersionNumberList[i].toInt()) {
        if (versionNumberList[i].toInt() < storeVersionNumberList[i].toInt()) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  ///showSnackBar
  static void handleMessage({
    String? message,
    bool isError = false,
    bool isWarning = false,
    Color? barColor,
    Color? iconColor,
    Color? textColor,
    Widget? child,
    Function()? onClick,
    String? buttonText,
    IconData? icon,
    String? title,
  }) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        margin: EdgeInsets.only(bottom: Get.context!.isPortrait ? 8.h : 5.h, left: 7.w, right: 7.w),
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: Duration(milliseconds: 375),
        duration: const Duration(milliseconds: 3000),
        backgroundColor:
        barColor ??
            (isError
                ? AppColors.ERROR_COLOR
                : isWarning
                ? AppColors.WARNING_COLOR
                : AppColors.SUCCESS_COLOR),
        borderRadius: 12,
        padding: Get.context != null
            ? Get.context!.isPortrait
            ? EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h)
            : EdgeInsets.symmetric(horizontal: 3.h, vertical: 1.w)
            : EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        messageText: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: TextStyle(
                  fontSize: 17.sp,
                  color: textColor ?? AppColors.WHITE_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon ??
                      (isError
                          ? Icons.error_rounded
                          : isWarning
                          ? Icons.warning_rounded
                          : Icons.check_circle_rounded),
                  color: iconColor ?? AppColors.WHITE_COLOR,
                ),
                SizedBox(
                  width: Get.context != null
                      ? Get.context!.isPortrait
                      ? 3.w
                      : 3.h
                      : 3.w,
                ),
                child ??
                    Expanded(
                      child: Text(
                        message ?? AppStrings.somethingWentWrong.tr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textColor ?? AppColors.WHITE_COLOR,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                if (onClick != null) ...[
                  SizedBox(width: 2.w),
                  TextButton(
                    onPressed: onClick,
                    style: TextButton.styleFrom(
                      elevation: 4,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: AppColors.WHITE_COLOR, width: 1),
                      ),
                    ),
                    child: Text(
                      buttonText ?? AppStrings.open.tr,
                      style: TextStyle(color: AppColors.WHITE_COLOR, fontSize: 15.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    }
  }
}
