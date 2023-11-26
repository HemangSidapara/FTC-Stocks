import 'package:flutter/material.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_view.dart';
import 'package:get/get.dart';

class DashboardNavigator extends StatelessWidget {
  const DashboardNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(0),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.addStockScreen:
            return GetPageRoute(
              routeName: Routes.addStockScreen,
              page: () => const AddStockView(),
              binding: AddStockBindings(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
              settings: RouteSettings(
                arguments: settings.arguments,
              ),
            );
          case Routes.createOrderScreen:
            return GetPageRoute(
              routeName: Routes.createOrderScreen,
              page: () => const CreateOrderView(),
              binding: CreateOrderBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
              settings: RouteSettings(
                arguments: settings.arguments,
              ),
            );
          default:
            return GetPageRoute(
              routeName: Routes.dashboardScreen,
              page: () => const DashboardView(),
              binding: DashboardBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
            );
        }
      },
    );
  }
}
