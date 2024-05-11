import 'package:flutter/material.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/pending_orders_screen/pending_orders_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/pending_orders_screen/pending_orders_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/required_stock_screen/required_stock_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/required_stock_screen/required_stock_view.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/total_stock_in_house_screen/total_stock_in_house_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/total_stock_in_house_screen/total_stock_in_house_view.dart';
import 'package:get/get.dart';

class DashboardNavigator extends StatelessWidget {
  const DashboardNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(0),
      onGenerateRoute: (settings) {
        switch (settings.name) {
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

          case Routes.pendingOrdersScreen:
            return GetPageRoute(
              routeName: Routes.pendingOrdersScreen,
              page: () => const PendingOrdersView(),
              binding: PendingOrdersBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
              settings: RouteSettings(
                arguments: settings.arguments,
              ),
            );

          case Routes.challanScreen:
            return GetPageRoute(
              routeName: Routes.challanScreen,
              page: () => const ChallanView(),
              binding: ChallanBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
              settings: RouteSettings(
                arguments: settings.arguments,
              ),
            );

          case Routes.requiredStockScreen:
            return GetPageRoute(
              routeName: Routes.requiredStockScreen,
              page: () => const RequiredStockView(),
              binding: RequiredStockBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
              settings: RouteSettings(
                arguments: settings.arguments,
              ),
            );

          case Routes.totalStockInHouseScreen:
            return GetPageRoute(
              routeName: Routes.totalStockInHouseScreen,
              page: () => const TotalStockInHouseView(),
              binding: TotalStockInHouseBinding(),
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
