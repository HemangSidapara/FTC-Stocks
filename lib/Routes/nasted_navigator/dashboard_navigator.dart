import 'package:flutter/material.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_stocks_screen/create_stocks_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_stocks_screen/create_stocks_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_view.dart';
import 'package:get/get.dart';

class DashboardNavigator extends StatelessWidget {
  static final GlobalKey<NavigatorState> dashboardNavigatorKey = GlobalKey<NavigatorState>();

  const DashboardNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(0),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.createStocksScreen:
            return GetPageRoute(
              routeName: Routes.createStocksScreen,
              page: () => const CreateStocksView(),
              binding: CreateStocksBindings(),
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
