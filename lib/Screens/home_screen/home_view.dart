import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Screens/home_screen/add_new_product_screen/add_new_product_controller.dart';
import 'package:ftc_stocks/Screens/home_screen/home_controller.dart';
import 'package:ftc_stocks/Widgets/exit_app_dialog_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (Get.keys[0]?.currentState?.canPop() == true) {
          controller.onBottomItemChange(index: 0);
        } else {
          if (Get.isRegistered<AddNewProductController>()) {
            Get.find<AddNewProductController>().selectedCategory.value = -1;
          }
          if (controller.bottomIndex.value != 0) {
            controller.onBottomItemChange(index: 0);
          } else if (Get.keys[0]?.currentState?.canPop() != true) {
            showExitAppDialog(context: context);
          }
        }
      },

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.WHITE_COLOR,
        extendBodyBehindAppBar: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.LIGHT_SECONDARY_COLOR,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AssetImages(index: 0, iconName: AppAssets.homeIcon),
              if (controller.isAdmin) AssetImages(index: 1, iconName: AppAssets.addNewProductIcon),
              if (controller.isAdmin) AssetImages(index: 2, iconName: AppAssets.ordersHistoryIcon),
              AssetImages(index: 3, iconName: AppAssets.settingsIcon),
            ],
          ),
        ),
        body: SafeArea(
          child: PageView(
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
          child: SizedBox(
            height: 12.w,
            width: 12.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconName,
                  width: index == 1 ? 9.5.w : 8.w,
                  color: controller.bottomIndex.value == index ? AppColors.PRIMARY_COLOR : AppColors.LIGHT_BLACK_COLOR,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
