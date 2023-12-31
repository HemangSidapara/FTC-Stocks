import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/pending_orders_screen/pending_orders_controller.dart';
import 'package:get/get.dart';

class PendingOrdersBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PendingOrdersController());
  }
}
