import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/api_keys.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Network/services/add_stock_service/add_stock_service.dart';
import 'package:ftc_stocks/Network/services/create_order_service/create_order_service.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:get/get.dart';

class CreateOrderController extends GetxController {
  RxBool isGetStockLoading = true.obs;
  RxBool isAddOrderLoading = false.obs;

  GlobalKey<FormState> createOrderFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  RxList<get_stock.Data> productDataList = RxList<get_stock.Data>();

  List<String> productList = [];
  RxInt selectedProduct = (-1).obs;

  RxList<String> defaultList = RxList(
    [
      AppStrings.three,
      AppStrings.four,
      AppStrings.six,
      AppStrings.eight,
      AppStrings.ten,
      AppStrings.twelve,
    ],
  );
  RxList<String> sizeList = RxList(
    [
      AppStrings.three,
      AppStrings.four,
      AppStrings.six,
      AppStrings.eight,
      AppStrings.ten,
      AppStrings.twelve,
    ],
  );
  RxList<String> customSizeList = RxList();
  RxList<String> selectedSizeList = RxList();

  RxBool sizeThreeCheckbox = false.obs;
  RxBool sizeFourCheckbox = false.obs;
  RxBool sizeSixCheckbox = false.obs;
  RxBool sizeEightCheckbox = false.obs;
  RxBool sizeTenCheckbox = false.obs;
  RxBool sizeTwelveCheckbox = false.obs;
  RxList<RxBool> sizeCustomCheckboxList = RxList();

  TextEditingController sizeThreeWeightOfPieceController = TextEditingController();
  TextEditingController sizeFourWeightOfPieceController = TextEditingController();
  TextEditingController sizeSixWeightOfPieceController = TextEditingController();
  TextEditingController sizeEightWeightOfPieceController = TextEditingController();
  TextEditingController sizeTenWeightOfPieceController = TextEditingController();
  TextEditingController sizeTwelveWeightOfPieceController = TextEditingController();
  RxList<TextEditingController> sizeCustomWeightOfPieceControllerList = RxList();

  TextEditingController sizeThreeQuantityController = TextEditingController();
  TextEditingController sizeFourQuantityController = TextEditingController();
  TextEditingController sizeSixQuantityController = TextEditingController();
  TextEditingController sizeEightQuantityController = TextEditingController();
  TextEditingController sizeTenQuantityController = TextEditingController();
  TextEditingController sizeTwelveQuantityController = TextEditingController();
  RxList<TextEditingController> sizeCustomQuantityControllerList = RxList();

  TextEditingController sizeThreeWeightController = TextEditingController();
  TextEditingController sizeFourWeightController = TextEditingController();
  TextEditingController sizeSixWeightController = TextEditingController();
  TextEditingController sizeEightWeightController = TextEditingController();
  TextEditingController sizeTenWeightController = TextEditingController();
  TextEditingController sizeTwelveWeightController = TextEditingController();
  RxList<TextEditingController> sizeCustomWeightControllerList = RxList();

  TextEditingController orderSizeThreeQuantityController = TextEditingController();
  TextEditingController orderSizeFourQuantityController = TextEditingController();
  TextEditingController orderSizeSixQuantityController = TextEditingController();
  TextEditingController orderSizeEightQuantityController = TextEditingController();
  TextEditingController orderSizeTenQuantityController = TextEditingController();
  TextEditingController orderSizeTwelveQuantityController = TextEditingController();
  RxList<TextEditingController> orderSizeCustomQuantityControllerList = RxList();

  TextEditingController orderSizeThreeWeightController = TextEditingController();
  TextEditingController orderSizeFourWeightController = TextEditingController();
  TextEditingController orderSizeSixWeightController = TextEditingController();
  TextEditingController orderSizeEightWeightController = TextEditingController();
  TextEditingController orderSizeTenWeightController = TextEditingController();
  TextEditingController orderSizeTwelveWeightController = TextEditingController();
  RxList<TextEditingController> orderSizeCustomWeightControllerList = RxList();

  @override
  void onInit() async {
    super.onInit();
    await getStockApiCall();
  }

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPartyName.tr;
    }
    return null;
  }

  String? validateProduct(String? value) {
    if (value == null || value.isEmpty) {
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
    if (weightOfPieceController.text.trim().isNotEmpty) {
      if (value.isNotEmpty) {
        weightController.text = ((weightOfPieceController.text.trim().toDouble() * quantityController.text.trim().toDouble()) / (unitOfWeight.value == 0 ? 1000 : 1)).toString();
      } else {
        weightController.clear();
      }
    } else if (value.isNotEmpty && weightController.text.trim().isNotEmpty) {
      weightOfPieceController.text = ((weightController.text.trim().toDouble() * 1000) / quantityController.text.trim().toDouble()).toStringAsFixed(2);
    }
  }

  void calculateQuantityByWeight(String value, TextEditingController quantityController, TextEditingController weightController, TextEditingController weightOfPieceController, RxInt unitOfWeight) {
    if (weightOfPieceController.text.trim().isNotEmpty) {
      if (value.isNotEmpty) {
        quantityController.text = ((weightController.text.trim().toDouble() * (unitOfWeight.value == 0 ? 1000 : 1)) / weightOfPieceController.text.trim().toDouble()).roundToDouble().toString();
      } else {
        quantityController.clear();
      }
    } else if (value.isNotEmpty && quantityController.text.trim().isNotEmpty) {
      weightOfPieceController.text = ((weightController.text.trim().toDouble() * 1000) / quantityController.text.trim().toDouble()).toStringAsFixed(2);
    }
  }

  Future<List<String>> getStockApiCall({bool isLoading = true}) async {
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
      return productList;
    } finally {
      isGetStockLoading(false);
    }
  }

  Future<void> checkAddOrder() async {
    final isValid = createOrderFormKey.currentState?.validate();

    if (isValid == true) {
      if (isChecked()) {
        try {
          isAddOrderLoading(true);
          List<Map<String, String>> orderData = List.empty(growable: true);
          for (int i = 0; i < selectedSizeList.length; i++) {
            switch (selectedSizeList[i]) {
              case '3':
                if (sizeThreeCheckbox.isTrue) {
                  orderData.add({
                    ApiKeys.size: '3',
                    ApiKeys.weight: orderSizeThreeWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                    ApiKeys.piece: orderSizeThreeQuantityController.text.trim(),
                  });
                }
              case '4':
                if (sizeFourCheckbox.isTrue) {
                  orderData.add({
                    ApiKeys.size: '4',
                    ApiKeys.weight: orderSizeFourWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                    ApiKeys.piece: orderSizeFourQuantityController.text.trim(),
                  });
                }
              case '6':
                if (sizeSixCheckbox.isTrue) {
                  orderData.add({
                    ApiKeys.size: '6',
                    ApiKeys.weight: orderSizeSixWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                    ApiKeys.piece: orderSizeSixQuantityController.text.trim(),
                  });
                }
              case '8':
                if (sizeEightCheckbox.isTrue) {
                  orderData.add({
                    ApiKeys.size: '8',
                    ApiKeys.weight: orderSizeEightWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                    ApiKeys.piece: orderSizeEightQuantityController.text.trim(),
                  });
                }
              case '10':
                if (sizeTenCheckbox.isTrue) {
                  orderData.add({
                    ApiKeys.size: '10',
                    ApiKeys.weight: orderSizeTenWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                    ApiKeys.piece: orderSizeTenQuantityController.text.trim(),
                  });
                }
              case '12':
                if (sizeTwelveCheckbox.isTrue) {
                  orderData.add({
                    ApiKeys.size: '12',
                    ApiKeys.weight: orderSizeTwelveWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                    ApiKeys.piece: orderSizeTwelveQuantityController.text.trim(),
                  });
                }
              default:
                final tempCustomItemIndex = customSizeList.indexOf(selectedSizeList[i]);
                if (sizeCustomCheckboxList[tempCustomItemIndex].isTrue) {
                  orderData.add({
                    ApiKeys.size: selectedSizeList[i].trim(),
                    ApiKeys.weight: orderSizeCustomWeightControllerList[tempCustomItemIndex].text.trim().notContainsAndAddSubstring(' kg'),
                    ApiKeys.piece: orderSizeCustomQuantityControllerList[tempCustomItemIndex].text.trim(),
                  });
                }
            }
          }

          final response = await CreateOrderService().createOrdersService(
            partyName: partyNameController.text.trim(),
            modelId: productDataList[selectedProduct.value].modelId ?? '',
            orderData: orderData,
          );

          if (response.isSuccess) {
            Get.back(id: 0);
            Utils.handleMessage(message: response.message);
          }
        } finally {
          isAddOrderLoading(false);
        }
      } else {
        Utils.handleMessage(message: AppStrings.pleaseSelectAnySizeForTheOrder.tr, isError: true);
      }
    }
  }

  bool isChecked() {
    return sizeThreeCheckbox.isTrue || sizeFourCheckbox.isTrue || sizeSixCheckbox.isTrue || sizeEightCheckbox.isTrue || sizeTenCheckbox.isTrue || sizeTwelveCheckbox.isTrue || sizeCustomCheckboxList.any((element) => element.value);
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

    sizeCustomWeightOfPieceControllerList.clear();
    sizeCustomQuantityControllerList.clear();
    sizeCustomWeightControllerList.clear();
    sizeCustomCheckboxList.clear();
    orderSizeCustomQuantityControllerList.clear();
    orderSizeCustomWeightControllerList.clear();
  }

  void initCustomControllers() {
    sizeCustomCheckboxList.add(false.obs);
    sizeCustomWeightOfPieceControllerList.add(TextEditingController());
    sizeCustomQuantityControllerList.add(TextEditingController());
    sizeCustomWeightControllerList.add(TextEditingController());
    orderSizeCustomQuantityControllerList.add(TextEditingController());
    orderSizeCustomWeightControllerList.add(TextEditingController());
  }
}
