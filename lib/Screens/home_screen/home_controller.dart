import 'package:flutter/material.dart';
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

  List<Widget> bottomItemWidgetList = [
    const DashboardNavigator(),
    const AddNewProductNavigator(),
    const OrdersHistoryNavigator(),
    const SettingsNavigator(),
  ];

  Future<void> onBottomItemChange({required int index}) async {
    bottomIndex.value = index;
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
        await Get.find<OrdersHistoryController>().getOrdersApiCall(isLoading: false);
      }
    } else if (index == 3) {
      if (Get.keys[3]?.currentState?.canPop() == true) {
        Get.back(id: 3);
      }
    }
    pageController.animateToPage(
      bottomIndex.value,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
