import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_controller.dart';
import 'package:get/get.dart';

class AddStockBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AddStockController());
  }
}
