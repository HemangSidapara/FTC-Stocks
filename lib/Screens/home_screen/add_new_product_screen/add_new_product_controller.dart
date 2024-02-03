import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/api_keys.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/services/add_stock_service/add_stock_service.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddNewProductController extends GetxController {
  RxBool isFormReset = true.obs;
  RxBool isAddProductLoading = false.obs;

  GlobalKey<FormState> addProductFormKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();

  List<String> categoryList = [
    AppStrings.handle,
    AppStrings.mainDoor,
    AppStrings.dabbi,
  ];
  RxInt selectedCategory = (-1).obs;

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
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterProductName.tr;
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
      quantityController.text = ((weightController.text.toDouble() * (unitOfWeight.value == 0 ? 1000 : 1)) / weightOfPieceController.text.toDouble()).roundToDouble().toString();
    } else {
      quantityController.clear();
    }
  }

  Future<void> checkAddProduct() async {
    final isValid = addProductFormKey.currentState?.validate();
    if (isValid == true) {
      try {
        isAddProductLoading(true);
        List<Map<String, String>> sizeData = List.empty(growable: true);
        for (int i = 0; i < selectedSizeList.length; i++) {
          switch (selectedSizeList[i]) {
            case '3':
              sizeData.add({
                ApiKeys.size: '3',
                ApiKeys.weightOfPiece: sizeThreeWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeThreeUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: sizeThreeWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                ApiKeys.piece: sizeThreeQuantityController.text.trim(),
              });
            case '4':
              sizeData.add({
                ApiKeys.size: '4',
                ApiKeys.weightOfPiece: sizeFourWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeFourUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: sizeFourWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                ApiKeys.piece: sizeFourQuantityController.text.trim(),
              });
            case '6':
              sizeData.add({
                ApiKeys.size: '6',
                ApiKeys.weightOfPiece: sizeSixWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeSixUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: sizeSixWeightController.text.notContainsAndAddSubstring(' kg'),
                ApiKeys.piece: sizeSixQuantityController.text.trim(),
              });
            case '8':
              sizeData.add({
                ApiKeys.size: '8',
                ApiKeys.weightOfPiece: sizeEightWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeEightUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: sizeEightWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                ApiKeys.piece: sizeEightQuantityController.text.trim(),
              });
            case '10':
              sizeData.add({
                ApiKeys.size: '10',
                ApiKeys.weightOfPiece: sizeTenWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeTenUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: sizeTenWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                ApiKeys.piece: sizeTenQuantityController.text.trim(),
              });
            case '12':
              sizeData.add({
                ApiKeys.size: '12',
                ApiKeys.weightOfPiece: sizeTwelveWeightOfPieceController.text.trim().notContainsAndAddSubstring(selectedSizeTwelveUnitOfWeight.value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: sizeTwelveWeightController.text.trim().notContainsAndAddSubstring(' kg'),
                ApiKeys.piece: sizeTwelveQuantityController.text.trim(),
              });
          }
        }

        if (isAddedCustomSize.isTrue && customProductSizeTagsController.hasTags) {
          for (int i = 0; i < (customProductSizeTagsController.getTags?.length ?? 0); i++) {
            if (customProductSizeTagsController.getTags?[i] != null) {
              sizeData.add({
                ApiKeys.size: customProductSizeTagsController.getTags?[i].trim() ?? '',
                ApiKeys.weightOfPiece: sizeCustomWeightOfPieceControllerList[i].text.trim().notContainsAndAddSubstring(selectedSizeCustomUnitOfWeightList[i].value == 0 ? ' gm' : ' kg'),
                ApiKeys.weight: sizeCustomWeightControllerList[i].text.trim().notContainsAndAddSubstring(' kg'),
                ApiKeys.piece: sizeCustomQuantityControllerList[i].text.trim(),
              });
            }
          }
        }

        final response = await AddStockService().addStockService(
          productName: productNameController.text,
          categoryName: categoryList[selectedCategory.value],
          sizeData: sizeData,
        );

        if (response.isSuccess) {
          resetSizeControllers();
          customProductSizeTagsController.clearTags();
          isAddedCustomSize(false);
          Utils.handleMessage(message: response.message);
        }
      } finally {
        isAddProductLoading(false);
      }
    }
  }

  void resetSizeControllers() {
    addProductFormKey.currentState?.reset();
    isFormReset(false);
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

    sizeCustomWeightOfPieceControllerList.clear();
    selectedSizeCustomUnitOfWeightList.clear();
    sizeCustomQuantityControllerList.clear();
    sizeCustomWeightControllerList.clear();
    customProductSizeController.clear();

    selectedSizeList.clear();
    productNameController.clear();
    selectedCategory.value = -1;

    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        isFormReset(true);
        update();
      },
    );
  }

  void initCustomControllers() {
    selectedSizeCustomUnitOfWeightList.add((-1).obs);
    sizeCustomWeightOfPieceControllerList.add(TextEditingController());
    sizeCustomQuantityControllerList.add(TextEditingController());
    sizeCustomWeightControllerList.add(TextEditingController());
  }

  void deletingCustomControllers({required String tag}) {
    if (customProductSizeTagsController.getTags?.isNotEmpty == true) {
      final deletingIndex = customProductSizeTagsController.getTags!.indexOf(tag);
      selectedSizeCustomUnitOfWeightList.removeAt(deletingIndex);
      sizeCustomWeightOfPieceControllerList.removeAt(deletingIndex);
      sizeCustomQuantityControllerList.removeAt(deletingIndex);
      sizeCustomWeightControllerList.removeAt(deletingIndex);
    }
  }
}
