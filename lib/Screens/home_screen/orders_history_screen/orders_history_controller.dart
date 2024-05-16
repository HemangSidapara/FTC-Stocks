import 'package:flutter/cupertino.dart';
import 'package:ftc_stocks/Network/models/create_order_models/get_orders_model.dart' as get_orders;
import 'package:ftc_stocks/Network/services/create_order_service/create_order_service.dart';
import 'package:get/get.dart';

class OrdersHistoryController extends GetxController {
  RxBool isGetOrdersLoading = true.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  TextEditingController searchOrderHistoryController = TextEditingController();
  RxList<get_orders.Data> searchedOrdersDataList = RxList<get_orders.Data>();
  RxList<get_orders.Data> ordersDataList = RxList<get_orders.Data>();
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
      final response = await CreateOrderService().getOrdersService(isPending: false);

      if (response.isSuccess) {
        get_orders.GetOrdersModel getOrdersModel = get_orders.getOrdersModelFromJson(response.response.toString());
        searchedOrdersDataList.clear();
        ordersDataList.clear();
        searchedOrdersDataList.addAll(getOrdersModel.data?.toList() ?? []);
        ordersDataList.addAll(getOrdersModel.data?.toList() ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }
}
