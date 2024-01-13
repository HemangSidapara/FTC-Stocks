import 'package:get/get.dart';

class InProgressStockController extends GetxController {
  RxBool isGetStockLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;
}
