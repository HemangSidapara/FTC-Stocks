import 'package:ftc_stocks/Screens/signin_screen/signin_controller.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
  }
}
