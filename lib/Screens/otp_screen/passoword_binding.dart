import 'package:ftc_stocks/Screens/otp_screen/password_controller.dart';
import 'package:get/get.dart';

class PasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PasswordController());
  }
}
