import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Utils {
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
  }) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        margin: EdgeInsets.only(bottom: 12.w + 1.h, left: 7.w, right: 7.w),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 3500),
        backgroundColor: barColor ??
            (isError
                ? AppColors.ERROR_COLOR
                : isWarning
                    ? AppColors.WARNING_COLOR
                    : AppColors.SUCCESS_COLOR),
        borderRadius: 30,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        messageText: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_rounded
                  : isWarning
                      ? Icons.warning_rounded
                      : Icons.check_circle_rounded,
              color: iconColor ?? AppColors.WHITE_COLOR,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message ?? 'Empty message',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textColor ?? AppColors.WHITE_COLOR,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
