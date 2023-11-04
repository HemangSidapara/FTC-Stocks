import 'package:flutter/material.dart';
import 'package:ftc_stocks/Routes/nasted_navigator/dashboard_navigator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt bottomIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);

  List<Widget> bottomItemWidgetList = [
    const DashboardNavigator(),
    const DashboardNavigator(),
    const DashboardNavigator(),
    const DashboardNavigator(),
  ];

  Future<void> onBottomItemChange({required int index}) async {
    bottomIndex.value = index;
    pageController.jumpToPage(bottomIndex.value);
  }
}
