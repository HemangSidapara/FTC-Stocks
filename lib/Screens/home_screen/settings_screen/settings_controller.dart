import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  ExpansionTileController expansionTileController = ExpansionTileController();
  RxBool isGujaratiLang = true.obs;
  RxBool isHindiLang = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (getString(AppConstance.languageCode) == 'gu') {
      isGujaratiLang.value = true;
      isHindiLang.value = false;
    } else if (getString(AppConstance.languageCode) == 'hi') {
      isGujaratiLang.value = false;
      isHindiLang.value = true;
    } else if (getString(AppConstance.languageCode) == 'en') {
      isGujaratiLang.value = false;
      isHindiLang.value = false;
    } else {
      isGujaratiLang.value = false;
      isHindiLang.value = false;
    }
  }
}
