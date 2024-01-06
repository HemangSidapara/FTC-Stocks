import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/api_keys.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Network/services/add_stock_service/add_stock_service.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddStockController extends GetxController {
  RxBool isGetStockLoading = false.obs;
  RxBool isAddStockLoading = false.obs;
  RxBool isDeleteStockLoading = false.obs;
  RxString deletingName = ''.obs;
  final GlobalKey<DropdownSearchState<String>> dropdownKey = GlobalKey<DropdownSearchState<String>>();

  GlobalKey<FormState> addStockFormKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();

  List<String> categoryList = [
    AppStrings.handle,
    AppStrings.mainDoor,
    AppStrings.dabbi,
  ];
  RxInt selectedCategory = (-1).obs;

  RxList<get_stock.Data> productDataList = RxList<get_stock.Data>();

  RxList<String> productList = RxList();
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
  List<String> sizeList = [
    AppStrings.three,
    AppStrings.four,
    AppStrings.six,
    AppStrings.eight,
    AppStrings.ten,
    AppStrings.twelve,
  ];
  RxList<String> selectedSizeList = RxList();

  RxBool isAddedCustomSize = false.obs;
  TextfieldTagsController customProductSizeTagsController = TextfieldTagsController();
  TextEditingController customProductSizeController = TextEditingController();

  List<String> weightUnitList = [
    AppStrings.gram,
    AppStrings.kilogram,
  ];
  RxInt selectedSizeThreeUnitOfWeight = (-1).obs;
  RxInt selectedSizeFourUnitOfWeight = (-1).obs;
  RxInt selectedSizeSixUnitOfWeight = (-1).obs;
  RxInt selectedSizeEightUnitOfWeight = (-1).obs;
  RxInt selectedSizeTenUnitOfWeight = (-1).obs;
  RxInt selectedSizeTwelveUnitOfWeight = (-1).obs;
  RxList<RxInt> selectedSizeCustomUnitOfWeightList = RxList();

  TextEditingController sizeThreeWeightOfPieceController = TextEditingController();
  TextEditingController sizeFourWeightOfPieceController = TextEditingController();
  TextEditingController sizeSixWeightOfPieceController = TextEditingController();
  TextEditingController sizeEightWeightOfPieceController = TextEditingController();
  TextEditingController sizeTenWeightOfPieceController = TextEditingController();
  TextEditingController sizeTwelveWeightOfPieceController = TextEditingController();
  RxList<TextEditingController> sizeCustomWeightOfPieceControllerList = RxList();

  TextEditingController stockedSizeThreeQuantityController = TextEditingController();
  TextEditingController stockedSizeFourQuantityController = TextEditingController();
  TextEditingController stockedSizeSixQuantityController = TextEditingController();
  TextEditingController stockedSizeEightQuantityController = TextEditingController();
  TextEditingController stockedSizeTenQuantityController = TextEditingController();
  TextEditingController stockedSizeTwelveQuantityController = TextEditingController();
  RxList<TextEditingController> stockedSizeCustomQuantityControllerList = RxList();

  TextEditingController stockedSizeThreeWeightController = TextEditingController();
  TextEditingController stockedSizeFourWeightController = TextEditingController();
  TextEditingController stockedSizeSixWeightController = TextEditingController();
  TextEditingController stockedSizeEightWeightController = TextEditingController();
  TextEditingController stockedSizeTenWeightController = TextEditingController();
  TextEditingController stockedSizeTwelveWeightController = TextEditingController();
  RxList<TextEditingController> stockedSizeCustomWeightControllerList = RxList();

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

  @override
  void onInit() {
    super.onInit();
    customProductSizeTagsController.init((tag) => null, null, null, null, null, null);
  }

  String? validateCategory(int? value) {
    if (value == null) {
      return AppStrings.pleaseSelectCategory.tr;
    }
    return null;
  }

  String? validateProduct(String? value) {
    if ((value == null || value == '') && productNameController.text.isEmpty) {
      return AppStrings.pleaseSelectProduct.tr;
    }
    return null;
  }

  String? validateProductSize(List value) {
    if (value.isEmpty && (customProductSizeTagsController.getTags?.length ?? 0) == 0) {
      return AppStrings.pleaseSelectProductSize.tr;
    }
    return null;
  }

  String? validateWeightUnit(int? value) {
    if (value == null) {
      return AppStrings.pleaseSelectUnitOfWeight.tr;
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
    if (value.isNotEmpty) {
      weightController.text = ((weightOfPieceController.text.toDouble() * quantityController.text.toDouble()) / (unitOfWeight.value == 0 ? 1000 : 1)).toString();
    } else {
      weightController.clear();
    }
  }

  void calculateQuantityByWeight(String value, TextEditingController quantityController, TextEditingController weightController, TextEditingController weightOfPieceController, RxInt unitOfWeight) {
    if (value.isNotEmpty) {
      quantityController.text = ((weightController.text.toDouble() * (unitOfWeight.value == 0 ? 1000 : 1)) / weightOfPieceController.text.toDouble()).toString();
    } else {
      quantityController.clear();
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

  Future<void> checkAddStock() async {
    final isValid = addStockFormKey.currentState?.validate();
    if (isValid == true) {
      try {
        isAddStockLoading(true);
        List<Map<String, String>> sizeData = List.empty(growable: true);
        for (int i = 0; i < selectedSizeList.length; i++) {
          switch (selectedSizeList[i]) {
            case '3':
              sizeData.add({
                ApiKeys.size: '3',
                ApiKeys.weightOfPiece: sizeThreeWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeThreeUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: totalWeight(
                  stockedWeightController: stockedSizeThreeWeightController,
                  weightController: sizeThreeWeightController,
                ),
                ApiKeys.piece: totalQuantity(
                  stockedQuantityController: stockedSizeThreeQuantityController,
                  quantityController: sizeThreeQuantityController,
                ),
              });
            case '4':
              sizeData.add({
                ApiKeys.size: '4',
                ApiKeys.weightOfPiece: sizeFourWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeFourUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: totalWeight(
                  stockedWeightController: stockedSizeFourWeightController,
                  weightController: sizeFourWeightController,
                ),
                ApiKeys.piece: totalQuantity(
                  stockedQuantityController: stockedSizeFourQuantityController,
                  quantityController: sizeFourQuantityController,
                ),
              });
            case '6':
              sizeData.add({
                ApiKeys.size: '6',
                ApiKeys.weightOfPiece: sizeSixWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeSixUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: totalWeight(
                  stockedWeightController: stockedSizeSixWeightController,
                  weightController: sizeSixWeightController,
                ),
                ApiKeys.piece: totalQuantity(
                  stockedQuantityController: stockedSizeSixQuantityController,
                  quantityController: sizeSixQuantityController,
                ),
              });
            case '8':
              sizeData.add({
                ApiKeys.size: '8',
                ApiKeys.weightOfPiece: sizeEightWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeEightUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: totalWeight(
                  stockedWeightController: stockedSizeEightWeightController,
                  weightController: sizeEightWeightController,
                ),
                ApiKeys.piece: totalQuantity(
                  stockedQuantityController: stockedSizeEightQuantityController,
                  quantityController: sizeEightQuantityController,
                ),
              });
            case '10':
              sizeData.add({
                ApiKeys.size: '10',
                ApiKeys.weightOfPiece: sizeTenWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeTenUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: totalWeight(
                  stockedWeightController: stockedSizeTenWeightController,
                  weightController: sizeTenWeightController,
                ),
                ApiKeys.piece: totalQuantity(
                  stockedQuantityController: stockedSizeTenQuantityController,
                  quantityController: sizeTenQuantityController,
                ),
              });
            case '12':
              sizeData.add({
                ApiKeys.size: '12',
                ApiKeys.weightOfPiece: sizeTwelveWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeTwelveUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: totalWeight(
                  stockedWeightController: stockedSizeTwelveWeightController,
                  weightController: sizeTwelveWeightController,
                ),
                ApiKeys.piece: totalQuantity(
                  stockedQuantityController: stockedSizeTwelveQuantityController,
                  quantityController: sizeTwelveQuantityController,
                ),
              });
          }
        }

        if (isAddedCustomSize.isTrue && customProductSizeTagsController.hasTags) {
          for (int i = 0; i < (customProductSizeTagsController.getTags?.length ?? 0); i++) {
            if (customProductSizeTagsController.getTags?[i] != null) {
              sizeData.add({
                ApiKeys.size: customProductSizeTagsController.getTags?[i].trim() ?? '',
                ApiKeys.weightOfPiece: sizeCustomWeightOfPieceControllerList[i].text.trim().notContainsAndAddSubstring(selectedSizeCustomUnitOfWeightList[i].value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: totalWeight(
                  stockedWeightController: stockedSizeCustomWeightControllerList[i],
                  weightController: sizeCustomWeightControllerList[i],
                ),
                ApiKeys.piece: totalQuantity(
                  stockedQuantityController: stockedSizeCustomQuantityControllerList[i],
                  quantityController: sizeCustomQuantityControllerList[i],
                ),
              });
            }
          }
        }

        final response = await AddStockService().addStockService(
          productName: selectedProduct.value != -1 ? productList[selectedProduct.value] : productNameController.text.trim(),
          categoryName: categoryList[selectedCategory.value],
          sizeData: sizeData,
        );

        if (response.isSuccess) {
          Get.back(id: 0);
          Utils.validationCheck(message: response.message);
        }
      } finally {
        isAddStockLoading(false);
      }
    }
  }

  Future<void> deleteStockApiCall({required String modelID}) async {
    try {
      isDeleteStockLoading(true);
      final response = await AddStockService().deleteStockService(modelID: modelID);

      if (response.isSuccess) {
        dropdownKey.currentState?.closeDropDownSearch();
        Utils.validationCheck(message: response.message);
        await Future.delayed(
          const Duration(milliseconds: 500),
          () {
            dropdownKey.currentState?.openDropDownSearch();
          },
        );
      }
    } finally {
      isDeleteStockLoading(false);
    }
  }

  String totalQuantity({
    required TextEditingController stockedQuantityController,
    required TextEditingController quantityController,
  }) {
    return (stockedQuantityController.text.trim().toDouble() + (quantityController.text.trim().isEmpty ? 0 : quantityController.text.trim().toDouble())).toStringAsFixed(0).trim();
  }

  String totalWeight({
    required TextEditingController stockedWeightController,
    required TextEditingController weightController,
  }) {
    return (stockedWeightController.text.trim().toDouble() + (weightController.text.trim().isEmpty ? 0 : weightController.text.trim().toDouble())).toStringAsFixed(2).trim().notContainsAndAddSubstring(' kg');
  }

  void resetSizeControllers() {
    sizeThreeWeightOfPieceController.clear();
    selectedSizeThreeUnitOfWeight(-1);
    sizeThreeQuantityController.clear();
    sizeThreeWeightController.clear();

    sizeFourWeightOfPieceController.clear();
    selectedSizeFourUnitOfWeight(-1);
    sizeFourQuantityController.clear();
    sizeFourWeightController.clear();

    sizeSixWeightOfPieceController.clear();
    selectedSizeSixUnitOfWeight(-1);
    sizeSixQuantityController.clear();
    sizeSixWeightController.clear();

    sizeEightWeightOfPieceController.clear();
    selectedSizeEightUnitOfWeight(-1);
    sizeEightQuantityController.clear();
    sizeEightWeightController.clear();

    sizeTenWeightOfPieceController.clear();
    selectedSizeTenUnitOfWeight(-1);
    sizeTenQuantityController.clear();
    sizeTenWeightController.clear();

    sizeTwelveWeightOfPieceController.clear();
    selectedSizeTwelveUnitOfWeight(-1);
    sizeTwelveQuantityController.clear();
    sizeTwelveWeightController.clear();
  }

  void resetCustomSizeControllers() {
    sizeCustomWeightOfPieceControllerList.clear();
    selectedSizeCustomUnitOfWeightList.clear();
    sizeCustomQuantityControllerList.clear();
    sizeCustomWeightControllerList.clear();
  }

  void initCustomControllers() {
    selectedSizeCustomUnitOfWeightList.add((-1).obs);
    sizeCustomWeightOfPieceControllerList.add(TextEditingController());
    stockedSizeCustomQuantityControllerList.add(TextEditingController());
    stockedSizeCustomWeightControllerList.add(TextEditingController());
    sizeCustomQuantityControllerList.add(TextEditingController());
    sizeCustomWeightControllerList.add(TextEditingController());
  }

  void deletingCustomControllers({required String tag}) {
    if (customProductSizeTagsController.getTags?.isNotEmpty == true) {
      final deletingIndex = customProductSizeTagsController.getTags!.indexOf(tag);
      selectedSizeCustomUnitOfWeightList.removeAt(deletingIndex);
      sizeCustomWeightOfPieceControllerList.removeAt(deletingIndex);
      stockedSizeCustomQuantityControllerList.removeAt(deletingIndex);
      stockedSizeCustomWeightControllerList.removeAt(deletingIndex);
      sizeCustomQuantityControllerList.removeAt(deletingIndex);
      sizeCustomWeightControllerList.removeAt(deletingIndex);
    }
  }
}
