import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:get/get.dart';

class AddStockController extends GetxController {
  GlobalKey<FormState> addStockFormKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();

  List<String> categoryList = [
    AppStrings.handle,
    AppStrings.mainDoor,
    AppStrings.dabbi,
  ];

  List<String> productList = [
    AppStrings.handle,
    AppStrings.mainDoor,
    AppStrings.dabbi,
  ];

  List<String> sizeList = [
    AppStrings.three,
    AppStrings.four,
    AppStrings.six,
    AppStrings.eight,
    AppStrings.ten,
    AppStrings.twelve,
  ];
  RxList<String> selectedSizeList = RxList();

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

  Future<void> checkAddStock() async {
    final isValidate = addStockFormKey.currentState?.validate();

    if (isValidate == true) {}
  }
}
