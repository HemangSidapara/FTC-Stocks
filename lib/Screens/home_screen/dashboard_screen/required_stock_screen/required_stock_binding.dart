import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/required_stock_screen/required_stock_controller.dart';
import 'package:get/get.dart';

class RequiredStockBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RequiredStockController());
  }
}
