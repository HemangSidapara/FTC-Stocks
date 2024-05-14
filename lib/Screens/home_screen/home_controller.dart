import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:ftc_stocks/Network/services/auth_service/auth_service.dart';
import 'package:ftc_stocks/Network/services/utils_service/get_package_info_service.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/add_new_product_navigator.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/dashboard_navigator.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/orders_history_navigator.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/settings_navigator.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_controller.dart';
import 'package:ftc_stocks/Screens/home_screen/settings_screen/settings_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt bottomIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  RxBool isLatestVersionAvailable = false.obs;
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;

  List<Widget> bottomItemWidgetList = [
    const DashboardNavigator(),
    if (getData(AppConstance.role) == 'Admin') const AddNewProductNavigator(),
    if (getData(AppConstance.role) == 'Admin') const OrdersHistoryNavigator(),
    const SettingsNavigator(),
  ];

  Future<void> onBottomItemChange({required int index}) async {
    bottomIndex.value = index;
    AuthService().getLatestVersionService().then((response) async {
      GetLatestVersionModel versionModel = GetLatestVersionModel.fromJson(response.response?.data);
      if (response.isSuccess) {
        newAPKUrl(versionModel.data?.firstOrNull?.appUrl ?? '');
        newAPKVersion(versionModel.data?.firstOrNull?.appVersion ?? '');
        final currentVersion = (await GetPackageInfoService.instance.getInfo()).version;
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
