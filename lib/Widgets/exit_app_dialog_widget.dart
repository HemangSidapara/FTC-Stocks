import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> showExitAppDialog({required BuildContext context}) async {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'string',
    transitionDuration: const Duration(milliseconds: 600),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(animation),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: AppColors.WHITE_COLOR,
        surfaceTintColor: AppColors.WHITE_COLOR,
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.WHITE_COLOR,
          ),
          height: context.isPortrait ? 30.h : 60.h,
          width: context.isPortrait ? 80.w : 40.w,
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 5.w : 5.h, vertical: context.isPortrait ? 2.h : 2.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.WARNING_COLOR,
                size: context.isPortrait ? 10.w : 10.h,
              ),
              SizedBox(height: 2.h),
              Text(
                AppStrings.areYouSureYouWantToExitTheApp.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.ERROR_COLOR,
                  fontWeight: FontWeight.w600,
                  fontSize: context.isPortrait ? 12.sp : 7.sp,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///No
                  ButtonWidget(
                    onPressed: () {
                      Get.back();
                    },
                    buttonTitle: AppStrings.no.tr,
                    fixedSize: Size(context.isPortrait ? 30.w : 15.w, context.isPortrait ? 5.h : 12.h),
                  ),

                  ///Yes, exit
                  ButtonWidget(
                    onPressed: () async {
                      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                    },
                    buttonTitle: AppStrings.yesExit.tr,
                    buttonColor: AppColors.SECONDARY_COLOR,
                    fixedSize: Size(context.isPortrait ? 30.w : 15.w, context.isPortrait ? 5.h : 12.h),
                  ),
                ],
              ),
              SizedBox(height: context.isPortrait ? 2.h : 2.w),
            ],
          ),
        ),
      );
    },
  );
}
