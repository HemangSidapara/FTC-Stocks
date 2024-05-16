import 'package:flutter/material.dart';
import 'package:ftc_stocks/Network/models/challan_models/challan_model.dart' as challan_model;
import 'package:ftc_stocks/Network/services/challan_service/challan_service.dart';
import 'package:get/get.dart';

class ChallanController extends GetxController {
  RxBool isGetOrdersLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  TextEditingController searchPartyController = TextEditingController();
  RxList<challan_model.Data> competedOrdersDataList = RxList<challan_model.Data>();
  RxList<challan_model.Data> searchedCompetedOrdersDataList = RxList<challan_model.Data>();

  @override
  void onReady() async {
    await getCompletedOrdersApiCall();
  }

  Future<void> getCompletedOrdersApiCall({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetOrdersLoading(isLoading);
      final response = await ChallanService().getCompletedOrdersService();

      if (response.isSuccess) {
        challan_model.ChallanModel challanModel = challan_model.ChallanModel.fromJson(response.response?.data);
        competedOrdersDataList.clear();
        searchedCompetedOrdersDataList.clear();
        competedOrdersDataList.addAll(challanModel.data?.toList() ?? []);
        searchedCompetedOrdersDataList.addAll(challanModel.data?.toList() ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }
}
