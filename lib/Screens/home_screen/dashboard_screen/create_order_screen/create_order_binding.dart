import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_controller.dart';
import 'package:get/get.dart';

class CreateOrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CreateOrderController());
  }
}
