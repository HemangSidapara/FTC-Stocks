import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  List<String> contentRouteList = [
    Routes.addStockScreen,
    if (getData(AppConstance.role) == 'Admin') Routes.pendingOrdersScreen,
    Routes.requiredStockScreen,
    if (getData(AppConstance.role) == 'Admin') Routes.totalStockInHouseScreen,
  ];

  List<String> contentList = [
    AppStrings.addStock,
    if (getData(AppConstance.role) == 'Admin') AppStrings.pendingOrders,
    AppStrings.requiredStock,
    if (getData(AppConstance.role) == 'Admin') AppStrings.totalStockInHouse,
  ];

  List<String> contentIconList = [
    AppAssets.addStockIcon,
    if (getData(AppConstance.role) == 'Admin') AppAssets.pendingOrderIcon,
    AppAssets.requiredStockIcon,
    if (getData(AppConstance.role) == 'Admin') AppAssets.totalStockInHouseIcon,
  ];
}
