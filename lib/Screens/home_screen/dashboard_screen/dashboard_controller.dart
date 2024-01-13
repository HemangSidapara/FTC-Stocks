import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  List<String> contentRouteList = [
    Routes.addStockScreen,
    Routes.availableStockScreen,
    Routes.pendingOrdersScreen,
    Routes.challanScreen,
    Routes.requiredStockScreen,
    Routes.totalStockInHouseScreen,
  ];

  List<String> contentList = [
    AppStrings.addStock,
    AppStrings.availableStock,
    AppStrings.pendingOrders,
    AppStrings.challan,
    AppStrings.requiredStock,
    AppStrings.totalStockInHouse,
  ];

  List<String> contentIconList = [
    AppAssets.addStockIcon,
    AppAssets.totalStockIcon,
    AppAssets.pendingOrderIcon,
    AppAssets.challanIcon,
    AppAssets.requiredStockIcon,
    AppAssets.totalStockInHouseIcon,
  ];
}
