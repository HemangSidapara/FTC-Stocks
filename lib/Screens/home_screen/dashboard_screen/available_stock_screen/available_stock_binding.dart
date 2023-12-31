import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/available_stock_screen/available_stock_controller.dart';
import 'package:get/get.dart';

class AvailableStockBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AvailableStockController());
  }
}
