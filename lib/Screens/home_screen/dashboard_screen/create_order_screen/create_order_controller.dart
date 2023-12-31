import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Network/services/add_stock_service/add_stock_service.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
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

  RxBool sizeThreeCheckbox = false.obs;
  RxBool sizeFourCheckbox = false.obs;
  RxBool sizeSixCheckbox = false.obs;
  RxBool sizeEightCheckbox = false.obs;
  RxBool sizeTenCheckbox = false.obs;
  RxBool sizeTwelveCheckbox = false.obs;
  RxBool sizeCustomCheckbox = false.obs;

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

  TextEditingController orderSizeThreeQuantityController = TextEditingController();
  TextEditingController orderSizeFourQuantityController = TextEditingController();
  TextEditingController orderSizeSixQuantityController = TextEditingController();
  TextEditingController orderSizeEightQuantityController = TextEditingController();
  TextEditingController orderSizeTenQuantityController = TextEditingController();
  TextEditingController orderSizeTwelveQuantityController = TextEditingController();
  TextEditingController orderSizeCustomQuantityController = TextEditingController();

  TextEditingController orderSizeThreeWeightController = TextEditingController();
  TextEditingController orderSizeFourWeightController = TextEditingController();
  TextEditingController orderSizeSixWeightController = TextEditingController();
  TextEditingController orderSizeEightWeightController = TextEditingController();
  TextEditingController orderSizeTenWeightController = TextEditingController();
  TextEditingController orderSizeTwelveWeightController = TextEditingController();
  TextEditingController orderSizeCustomWeightController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await getStockApiCall();
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

  String? validateQuantity(String? value, TextEditingController quantityController) {
    if (value?.isEmpty == true) {
      return AppStrings.pleaseEnterQuantity.tr;
    } else if (value?.isDouble() == true && value?.isInt() == false) {
      return AppStrings.quantityMustBeAFractionValue.tr;
    } else if (value?.isInt() == true && value != null) {
      quantityController.text = double.parse(value).toInt().toString();
    }
    return null;
  }

  String? validateWeight(String? value) {
    if (value?.isEmpty == true) {
      return AppStrings.pleaseEnterWeight.tr;
    }
    return null;
  }

  void calculateWeightByQuantity(String value, TextEditingController weightController, TextEditingController quantityController, TextEditingController weightOfPieceController, RxInt unitOfWeight) {
    if (weightOfPieceController.text.isNotEmpty) {
      if (value.isNotEmpty) {
        weightController.text = ((weightOfPieceController.text.toDouble() * quantityController.text.toDouble()) / (unitOfWeight.value == 0 ? 1000 : 1)).toString();
      } else {
        weightController.clear();
      }
    }
  }

  void calculateQuantityByWeight(String value, TextEditingController quantityController, TextEditingController weightController, TextEditingController weightOfPieceController, RxInt unitOfWeight) {
    if (weightOfPieceController.text.isNotEmpty) {
      if (value.isNotEmpty) {
        quantityController.text = ((weightController.text.toDouble() * (unitOfWeight.value == 0 ? 1000 : 1)) / weightOfPieceController.text.toDouble()).toString();
      } else {
        quantityController.clear();
      }
    }
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

  Future<void> checkAddOrder() async {
    final isValid = createOrderFormKey.currentState?.validate();

    if (isValid == true) {
      if (isChecked()) {
      } else {
        Utils.validationCheck(message: AppStrings.pleaseSelectAnySizeForTheOrder.tr, isError: true);
      }
    }
  }

  bool isChecked() {
    return sizeThreeCheckbox.isTrue || sizeFourCheckbox.isTrue || sizeSixCheckbox.isTrue || sizeEightCheckbox.isTrue || sizeTenCheckbox.isTrue || sizeTwelveCheckbox.isTrue || sizeCustomCheckbox.isTrue;
  }

  void resetSizeControllers() {
    sizeThreeWeightOfPieceController.clear();
    sizeThreeQuantityController.clear();
    sizeThreeWeightController.clear();
    sizeThreeCheckbox(false);
    orderSizeThreeQuantityController.clear();
    orderSizeThreeWeightController.clear();

    sizeFourWeightOfPieceController.clear();
    sizeFourQuantityController.clear();
    sizeFourWeightController.clear();
    sizeFourCheckbox(false);
    orderSizeFourQuantityController.clear();
    orderSizeFourWeightController.clear();

    sizeSixWeightOfPieceController.clear();
    sizeSixQuantityController.clear();
    sizeSixWeightController.clear();
    sizeSixCheckbox(false);
    orderSizeSixQuantityController.clear();
    orderSizeSixWeightController.clear();

    sizeEightWeightOfPieceController.clear();
    sizeEightQuantityController.clear();
    sizeEightWeightController.clear();
    sizeEightCheckbox(false);
    orderSizeEightQuantityController.clear();
    orderSizeEightWeightController.clear();

    sizeTenWeightOfPieceController.clear();
    sizeTenQuantityController.clear();
    sizeTenWeightController.clear();
    sizeTenCheckbox(false);
    orderSizeTenQuantityController.clear();
    orderSizeTenWeightController.clear();

    sizeTwelveWeightOfPieceController.clear();
    sizeTwelveQuantityController.clear();
    sizeTwelveWeightController.clear();
    sizeTwelveCheckbox(false);
    orderSizeTwelveQuantityController.clear();
    orderSizeTwelveWeightController.clear();

    sizeCustomWeightOfPieceController.clear();
    sizeCustomQuantityController.clear();
    sizeCustomWeightController.clear();
    sizeCustomCheckbox(false);
    orderSizeCustomQuantityController.clear();
    orderSizeCustomWeightController.clear();
  }
}
