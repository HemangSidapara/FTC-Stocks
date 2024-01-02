import 'package:ftc_stocks/Screens/home_screen/add_new_product_screen/add_new_product_controller.dart';
import 'package:get/get.dart';

class AddNewProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AddNewProductController());
  }
}
