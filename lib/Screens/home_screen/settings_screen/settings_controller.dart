import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Network/services/utils_service/get_package_info_service.dart';
import 'package:ftc_stocks/Network/services/utils_service/install_apk_service.dart';
import 'package:ftc_stocks/Screens/home_screen/home_controller.dart';
import 'package:ftc_stocks/Utils/app_formatter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SettingsController extends GetxController {
  ExpansionTileController expansionTileController = ExpansionTileController();
  RxBool isGujaratiLang = true.obs;
  RxBool isHindiLang = true.obs;

  RxString appVersion = ''.obs;
  RxBool isUpdateLoading = false.obs;
  RxInt downloadedProgress = 0.obs;

  @override
  void onInit() async {
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
    appVersion.value = (await GetPackageInfoService.instance.getInfo()).version;
  }

  /// Download and install
  Future<void> downloadAndInstallService() async {
    try {
      isUpdateLoading(true);
      final directory = await getExternalStorageDirectory();
      final downloadPath = '${directory?.path}/app-release.apk';

      if (Get.find<HomeController>().newAPKUrl.value.isNotEmpty) {
        final downloadUrl = Get.find<HomeController>().newAPKUrl.value;
        final response = await Dio().downloadUri(
          Uri.parse(downloadUrl),
          downloadPath,
          onReceiveProgress: (counter, total) {
            if (total != -1) {
              debugPrint("Downloaded % :: ${(counter / total * 100).toStringAsFixed(0)}%");
              downloadedProgress.value = (counter / total * 100).toStringAsFixed(0).toInt();
            }
          },
        );

        if (response.statusCode == 200) {
          File file = File(downloadPath);
          if (await file.exists()) {
            await InstallApkService.instance.installApk();
            Utils.handleMessage(message: 'Downloaded successfully!');
          } else {
            Utils.handleMessage(message: 'Downloaded file not found.', isError: true);
          }
        } else {
          Utils.handleMessage(message: 'Failed to update.', isError: true);
        }
      } else {
        Utils.handleMessage(message: 'Failed to download.', isError: true);
      }
    } finally {
      isUpdateLoading(false);
    }
  }
}
