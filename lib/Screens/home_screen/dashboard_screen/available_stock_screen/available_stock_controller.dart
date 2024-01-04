import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Network/services/add_stock_service/add_stock_service.dart';
import 'package:get/get.dart';

class AvailableStockController extends GetxController {
  RxBool isGetStockLoading = true.obs;

  RxList<get_stock.Data> productDataList = RxList<get_stock.Data>();
  List<String> productList = [];

  @override
  void onReady() async {
    await getStockApiCall();
  }

  Future<void> getStockApiCall({bool isLoading = true}) async {
    try {
      isGetStockLoading(isLoading);
      final response = await AddStockService().getStockService();

      if (response.isSuccess) {
        get_stock.GetStockModel getStockModel = get_stock.getStockModelFromJson(response.response.toString());
        productDataList.clear();
        productList.clear();
        productDataList.addAll(getStockModel.data?.toList() ?? []);
        productList.addAll(getStockModel.data?.toList().map((e) => e.name ?? '').toList() ?? []);
      }
    } finally {
      isGetStockLoading(false);
    }
  }
}
