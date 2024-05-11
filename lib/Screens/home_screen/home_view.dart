import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Screens/home_screen/add_new_product_screen/add_new_product_controller.dart';
import 'package:ftc_stocks/Screens/home_screen/home_controller.dart';
import 'package:ftc_stocks/Widgets/exit_app_dialog_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
        systemNavigationBarColor: AppColors.WHITE_COLOR,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.WHITE_COLOR,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (Get.keys[0]?.currentState?.canPop() == true) {
          controller.onBottomItemChange(index: 0);
        } else {
          if (Get.isRegistered<AddNewProductController>()) {
            setState(() {
              Get.find<AddNewProductController>().selectedCategory.value = -1;
            });
          }
          if (controller.bottomIndex.value != 0) {
            controller.onBottomItemChange(index: 0);
          } else if (Get.keys[0]?.currentState?.canPop() != true) {
            showExitAppDialog(context: context);
          }
        }
      },
      child: SafeArea(
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
                if (getData(AppConstance.role) == 'Admin') AssetImages(index: 1, iconName: AppAssets.addNewProductIcon),
                if (getData(AppConstance.role) == 'Admin') AssetImages(index: 2, iconName: AppAssets.ordersHistoryIcon),
                AssetImages(index: 3, iconName: AppAssets.settingsIcon),
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
