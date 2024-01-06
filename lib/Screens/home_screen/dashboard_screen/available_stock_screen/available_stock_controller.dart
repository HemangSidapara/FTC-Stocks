import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/models/available_stock_models/get_available_stock_model.dart' as get_available_stock;
import 'package:ftc_stocks/Network/services/add_stock_service/add_stock_service.dart';
import 'package:ftc_stocks/Network/services/available_stock_service/available_stock_service.dart';
import 'package:get/get.dart';

class AvailableStockController extends GetxController {
  RxBool isGetStockLoading = true.obs;
  RxString deletingId = ''.obs;
  RxBool isRefreshing = false.obs;

  RxList<get_available_stock.Data> productDataList = RxList<get_available_stock.Data>();
  RxList<String> productList = RxList();

  @override
  void onReady() async {
    await getAvailableApiCall();
  }

  Future<void> getAvailableApiCall({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetStockLoading(isLoading);
      final response = await AvailableStockService().getAvailableStockService();

      if (response.isSuccess) {
        get_available_stock.GetAvailableStockModel getAvailableStockModel = get_available_stock.getAvailableStockModelFromJson(response.response.toString());
        productDataList.clear();
        productList.clear();
        productDataList.addAll(getAvailableStockModel.data?.toList() ?? []);
        productList.addAll(getAvailableStockModel.data?.toList().map((e) => e.name ?? '').toList() ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetStockLoading(false);
    }
  }

  Future<void> deleteStockApiCall({required String modelID}) async {
    final response = await AddStockService().deleteStockService(modelID: modelID);

    if (response.isSuccess) {
      await getAvailableApiCall(isLoading: false);
      Utils.validationCheck(message: response.message);
    }
  }
}
