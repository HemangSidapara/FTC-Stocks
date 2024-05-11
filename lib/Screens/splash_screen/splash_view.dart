import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/splash_screen/splash_controller.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.TRANSPARENT,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    AppAssets.splashImage,
                    width: 80.w,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return Text(
              AppConstance.appVersion.replaceAll('1.0.0', controller.currentVersion.value),
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR.withOpacity(0.55),
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            );
          }),
          Text(
            AppStrings.poweredByMindwaveInfoway,
            style: TextStyle(
              color: AppColors.PRIMARY_COLOR.withOpacity(0.55),
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
