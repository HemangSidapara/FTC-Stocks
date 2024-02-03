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
  RxList<String> orderList = RxList();
  RxList<String> searchedOrderList = RxList();
  RxString doneId = ''.obs;
  RxString cancelId = ''.obs;

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
        orderList.clear();
        searchedOrderList.clear();
        ordersDataList.addAll(getOrdersModel.data?.toList() ?? []);
        searchedOrdersDataList.addAll(getOrdersModel.data?.toList() ?? []);
        orderList.addAll(getOrdersModel.data?.toList().map((e) => e.name ?? '').toList() ?? []);
        searchedOrderList.addAll(getOrdersModel.data?.toList().map((e) => e.name ?? '').toList() ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }

  Future<void> cancelOrderApiCall({required String orderId}) async {
    final response = await CreateOrderService().cancelOrdersService(orderId: orderId);

    if (response.isSuccess) {
      await getOrdersApiCall(isLoading: false);
      Utils.handleMessage(message: response.message);
    }
  }

  Future<void> completeOrderApiCall({required String orderId}) async {
    final response = await CreateOrderService().completeOrdersService(orderId: orderId);

    if (response.isSuccess) {
      await getOrdersApiCall(isLoading: false);
      Utils.handleMessage(message: response.message);
    }
  }
}
