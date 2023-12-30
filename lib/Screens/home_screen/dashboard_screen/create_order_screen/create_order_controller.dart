import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Network/services/add_stock_service/add_stock_service.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  RxBool isGetStockLoading = true.obs;
  RxBool isAddOrderLoading = false.obs;

  GlobalKey<FormState> createOrderFormKey = GlobalKey<FormState>();

  TextEditingController categoryController = TextEditingController();

  RxList<get_stock.Data> productDataList = RxList<get_stock.Data>();

  List<String> productList = [];
  RxInt selectedProduct = (-1).obs;

  List<String> sizeList = [
    AppStrings.three,
    AppStrings.four,
    AppStrings.six,
    AppStrings.eight,
    AppStrings.ten,
    AppStrings.twelve,
  ];
  RxList<String> selectedSizeList = RxList();

  TextEditingController sizeThreeWeightOfPieceController = TextEditingController();
  TextEditingController sizeFourWeightOfPieceController = TextEditingController();
  TextEditingController sizeSixWeightOfPieceController = TextEditingController();
  TextEditingController sizeEightWeightOfPieceController = TextEditingController();
  TextEditingController sizeTenWeightOfPieceController = TextEditingController();
  TextEditingController sizeTwelveWeightOfPieceController = TextEditingController();
  TextEditingController sizeCustomWeightOfPieceController = TextEditingController();

  TextEditingController sizeThreeQuantityController = TextEditingController();
  TextEditingController sizeFourQuantityController = TextEditingController();
  TextEditingController sizeSixQuantityController = TextEditingController();
  TextEditingController sizeEightQuantityController = TextEditingController();
  TextEditingController sizeTenQuantityController = TextEditingController();
  TextEditingController sizeTwelveQuantityController = TextEditingController();
  TextEditingController sizeCustomQuantityController = TextEditingController();

  TextEditingController sizeThreeWeightController = TextEditingController();
  TextEditingController sizeFourWeightController = TextEditingController();
  TextEditingController sizeSixWeightController = TextEditingController();
  TextEditingController sizeEightWeightController = TextEditingController();
  TextEditingController sizeTenWeightController = TextEditingController();
  TextEditingController sizeTwelveWeightController = TextEditingController();
  TextEditingController sizeCustomWeightController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await getStockApiCall();
  }

  String? validateCategory(int? value) {
    if (value == null) {
      return AppStrings.pleaseSelectCategory.tr;
    }
    return null;
  }

  String? validateProduct(int? value) {
    if (value == null) {
      return AppStrings.pleaseSelectProduct.tr;
    }
    return null;
  }

  String? validateProductSize(List value) {
    if (value.isEmpty) {
      return AppStrings.pleaseSelectProductSize.tr;
    }
    return null;
  }

  Future<void> getStockApiCall() async {
    try {
      isGetStockLoading(true);
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

  Future<void> checkAddOrder() async {}

  void resetSizeControllers() {}
}
