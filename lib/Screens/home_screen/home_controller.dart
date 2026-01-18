import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:ftc_stocks/Network/services/auth_services/auth_services.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/add_new_product_navigator.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/dashboard_navigator.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/orders_history_navigator.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/settings_navigator.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_controller.dart';
import 'package:ftc_stocks/Screens/home_screen/settings_screen/settings_controller.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeController extends GetxController {
  RxInt bottomIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  RxBool isLatestVersionAvailable = false.obs;
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;

  List<Widget> bottomItemWidgetList = [
    const DashboardNavigator(),
    if ([AppConstance.admin].contains(getData(AppConstance.role))) const AddNewProductNavigator(),
    if ([AppConstance.admin].contains(getData(AppConstance.role))) const OrdersHistoryNavigator(),
    const SettingsNavigator(),
  ];

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.TRANSPARENT,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.TRANSPARENT,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  bool get isAdmin => [AppConstance.admin].contains(getData(AppConstance.role));

  Future<void> onBottomItemChange({required int index}) async {
    bottomIndex.value = index;
    AuthServices.getLatestVersionService().then((response) async {
      GetLatestVersionModel versionModel = GetLatestVersionModel.fromJson(response.response?.data ?? {});
      if (response.isSuccess) {
        newAPKUrl(versionModel.data?.firstOrNull?.appUrl ?? '');
        newAPKVersion(versionModel.data?.firstOrNull?.appVersion ?? '');
        final currentVersion = (await PackageInfo.fromPlatform()).version;
        debugPrint('currentVersion :: $currentVersion');
        debugPrint('newVersion :: ${newAPKVersion.value}');
        isLatestVersionAvailable.value = Utils.isUpdateAvailable(currentVersion, versionModel.data?.firstOrNull?.appVersion ?? currentVersion);
      }
    });
    if (index == 0) {
      if (Get.keys[0]?.currentState?.canPop() == true) {
        Get.back(id: 0);
      }
      if (Get.isRegistered<SettingsController>()) {
        if (Get.find<SettingsController>().expansionTileController.isExpanded) {
          Get.find<SettingsController>().expansionTileController.collapse();
        }
      }
    } else if (index == 1) {
      if (Get.keys[1]?.currentState?.canPop() == true) {
        Get.back(id: 1);
      }
    } else if (index == 2) {
      if (Get.keys[2]?.currentState?.canPop() == true) {
        Get.back(id: 2);
      }
      if (Get.isRegistered<OrdersHistoryController>()) {
        Get.find<OrdersHistoryController>().getOrdersApiCall(isLoading: false);
      }
    } else if (index == 3) {
      if (Get.keys[3]?.currentState?.canPop() == true) {
        Get.back(id: 3);
      }
    }
    pageController.jumpToPage(
      bottomIndex.value,
    );
  }
}
