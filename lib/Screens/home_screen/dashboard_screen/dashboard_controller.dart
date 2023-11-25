import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  List<String> contentList = [
    AppStrings.addStock,
    AppStrings.availableStock,
    AppStrings.pendingOrders,
    AppStrings.challan,
  ];

  List<String> contentIconList = [
    AppAssets.addStockIcon,
    AppAssets.totalStockIcon,
    AppAssets.pendingOrderIcon,
    AppAssets.challanIcon,
  ];
}
