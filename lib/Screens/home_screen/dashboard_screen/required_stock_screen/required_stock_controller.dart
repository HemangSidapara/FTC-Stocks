import 'package:flutter/material.dart';
import 'package:ftc_stocks/Network/models/required_stock_models/required_stock_model.dart' as get_stocks;
import 'package:ftc_stocks/Network/services/required_stock_service/required_stock_service.dart';
import 'package:get/get.dart';

class RequiredStockController extends GetxController {
  RxBool isGetStockLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  TextEditingController searchRequiredStockController = TextEditingController();
  RxList<get_stocks.Data> requiredStockDataList = RxList<get_stocks.Data>();
  RxList<get_stocks.Data> searchedRequiredStockDataList = RxList<get_stocks.Data>();
  RxList<String> requiredStockList = RxList();
  RxList<String> searchedRequiredStockList = RxList();

  @override
  void onReady() async {
    await getRequiredStockApiCall();
  }

  Future<void> getRequiredStockApiCall({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetStockLoading(isLoading);
      final response = await RequiredStockService().getRequiredStockService();

      if (response.isSuccess) {
        get_stocks.RequiredStockModel requiredStockModel = get_stocks.RequiredStockModel.fromJson(response.response?.data);
        requiredStockDataList.clear();
        searchedRequiredStockDataList.clear();
        requiredStockList.clear();
        searchedRequiredStockList.clear();
        requiredStockDataList.addAll(requiredStockModel.data?.toList() ?? []);
        searchedRequiredStockDataList.addAll(requiredStockModel.data?.toList() ?? []);
        requiredStockList.addAll(requiredStockModel.data?.toList().map((e) => e.name ?? '').toList() ?? []);
        searchedRequiredStockList.addAll(requiredStockModel.data?.toList().map((e) => e.name ?? '').toList() ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetStockLoading(false);
    }
  }
}
