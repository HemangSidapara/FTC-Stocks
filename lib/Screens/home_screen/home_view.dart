import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Screens/home_screen/home_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.WHITE_COLOR,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (Get.keys[0]?.currentState?.canPop() == true) {
          Get.keys[0]?.currentState?.pop(true);
        } else {
          if (controller.bottomIndex.value == 0) {
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          } else {
            controller.bottomIndex.value = 0;
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.WHITE_COLOR,
          extendBodyBehindAppBar: true,
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            decoration: BoxDecoration(
              color: AppColors.LIGHT_SECONDARY_COLOR,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AssetImages(index: 0, iconName: AppAssets.homeIcon),
                AssetImages(index: 1, iconName: AppAssets.settingsIcon),
              ],
            ),
          ),
          body: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: controller.bottomItemWidgetList,
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AssetImages({
    required int index,
    required String iconName,
  }) {
    return Obx(
      () {
        return InkWell(
          onTap: () async {
            await controller.onBottomItemChange(index: index);
          },
          child: Image.asset(
            iconName,
            width: 8.w,
            color: controller.bottomIndex.value == index ? AppColors.PRIMARY_COLOR : AppColors.LIGHT_BLACK_COLOR,
          ),
        );
      },
    );
  }
}
