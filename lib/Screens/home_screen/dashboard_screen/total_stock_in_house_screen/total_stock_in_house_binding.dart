import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/total_stock_in_house_screen/total_stock_in_house_controller.dart';
import 'package:get/get.dart';

class TotalStockInHouseBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(TotalStockInHouseController());
  }
}
