import 'package:flutter/material.dart';
import 'package:ftc_stocks/Network/models/total_stock_in_house_models/total_stock_in_house_model.dart' as get_stocks;
import 'package:ftc_stocks/Network/services/total_stock_in_house_service/total_stock_in_house_service.dart';
import 'package:get/get.dart';

class TotalStockInHouseController extends GetxController {
  RxBool isGetStockLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  TextEditingController searchTotalStockInHouseController = TextEditingController();
  RxList<get_stocks.Data> stocksDataList = RxList<get_stocks.Data>();
  RxList<get_stocks.Data> searchedStocksDataList = RxList<get_stocks.Data>();

  @override
  void onInit() async {
    super.onInit();
    await totalStockInHouseApiCall();
  }

  Future<void> totalStockInHouseApiCall({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetStockLoading(isLoading);
      final response = await TotalStockInHouseService().totalStockInHouseService();

      if (response.isSuccess) {
        get_stocks.TotalStockInHouseModel stockInHouseModel = get_stocks.TotalStockInHouseModel.fromJson(response.response?.data);

        stocksDataList.clear();
        searchedStocksDataList.clear();
        stocksDataList.addAll(stockInHouseModel.data ?? []);
        searchedStocksDataList.addAll(stockInHouseModel.data ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetStockLoading(false);
    }
  }
}
