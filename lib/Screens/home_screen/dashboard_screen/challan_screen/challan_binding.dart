import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:get/get.dart';

class ChallanBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChallanController());
  }
}
