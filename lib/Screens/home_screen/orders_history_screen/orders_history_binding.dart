import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_controller.dart';
import 'package:get/get.dart';

class OrdersHistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(OrdersHistoryController());
  }
}
