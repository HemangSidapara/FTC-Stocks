import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/in_progress_stock_screen/in_progress_stock_controller.dart';
import 'package:get/get.dart';

class InProgressStockBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(InProgressStockController());
  }
}
