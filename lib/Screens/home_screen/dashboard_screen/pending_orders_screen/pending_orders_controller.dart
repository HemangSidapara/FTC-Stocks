import 'package:flutter/cupertino.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/models/create_order_models/get_orders_model.dart' as get_orders;
import 'package:ftc_stocks/Network/services/create_order_service/create_order_service.dart';
import 'package:get/get.dart';

class PendingOrdersController extends GetxController {
  RxBool isGetOrdersLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  TextEditingController searchPendingOrdersController = TextEditingController();
  RxList<get_orders.Data> ordersDataList = RxList<get_orders.Data>();
  RxList<get_orders.Data> searchedOrdersDataList = RxList<get_orders.Data>();

  RxString cancelId = ''.obs;
  RxString completeId = ''.obs;
  RxBool isCancelOrderLoading = false.obs;
  RxBool isCompleteOrderLoading = false.obs;

  @override
  void onReady() async {
    await getOrdersApiCall();
  }

  Future<void> getOrdersApiCall({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetOrdersLoading(isLoading);
      final response = await CreateOrderService().getOrdersService();

      if (response.isSuccess) {
        get_orders.GetOrdersModel getOrdersModel = get_orders.getOrdersModelFromJson(response.response.toString());
        ordersDataList.clear();
        searchedOrdersDataList.clear();
        ordersDataList.addAll(getOrdersModel.data?.toList() ?? []);
        searchedOrdersDataList.addAll(getOrdersModel.data?.toList() ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }

  Future<void> cancelOrderApiCall({required String metaId}) async {
    try {
      isCancelOrderLoading(true);
      cancelId(metaId);
      final response = await CreateOrderService().cancelOrdersService(metaId: metaId);

      if (response.isSuccess) {
        cancelId('');
        await getOrdersApiCall(isLoading: false);
        Utils.handleMessage(message: response.message);
      }
    } finally {
      isCancelOrderLoading(false);
    }
  }

  Future<void> completeOrderApiCall({required String metaId}) async {
    try {
      isCompleteOrderLoading(true);
      completeId(metaId);
      final response = await CreateOrderService().completeOrdersService(metaId: metaId);

      if (response.isSuccess) {
        completeId('');
        await getOrdersApiCall(isLoading: false);
        Utils.handleMessage(message: response.message);
      }
    } finally {
      isCompleteOrderLoading(false);
    }
  }
}
