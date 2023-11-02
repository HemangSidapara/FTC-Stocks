import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:get/get.dart';

class Utils {
  static void warningMessage(String message) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        "Warning!",
        message, /* backgroundColor: ThemeColors.colorWarningMessage, colorText: Colors.black*/
      );
    }
  }

  static void warningMessageWithTitle({String? title, String? message}) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        title ?? "Warning!",
        message!,
      );
    }
  }

  static void handleNetworkError(message) {
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        "Error",
        message,
      );
    }
  }

  ///showSnackBar
  static void validationCheck({String? message, bool isError = false, Color? barColor, Color? iconColor, Color? textColor}) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        margin: EdgeInsets.only(bottom: 5.h, left: 7.w, right: 7.w),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 3500),
        backgroundColor: barColor ?? (isError ? AppColors.ERROR_COLOR : AppColors.SUCCESS_COLOR),
        borderRadius: 30,
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
        messageText: Row(
          children: [
            Icon(
              isError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: iconColor ?? AppColors.WHITE_COLOR,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message ?? 'Empty message',
                style: TextStyle(
                  fontSize: 12.sp,
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
