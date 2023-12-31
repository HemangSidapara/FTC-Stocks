import 'package:flutter/material.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_view.dart';
import 'package:get/get.dart';

class OrdersHistoryNavigator extends StatelessWidget {
  const OrdersHistoryNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(1),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          default:
            return GetPageRoute(
              routeName: Routes.ordersHistoryScreen,
              page: () => const OrdersHistoryView(),
              binding: OrdersHistoryBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
            );
        }
      },
    );
  }
}
