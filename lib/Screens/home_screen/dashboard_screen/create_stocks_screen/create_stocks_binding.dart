import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_stocks_screen/create_stocks_controller.dart';
import 'package:get/get.dart';

class CreateStocksBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CreateStocksController());
  }
}
