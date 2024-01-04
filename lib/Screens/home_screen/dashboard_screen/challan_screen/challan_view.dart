import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:get/get.dart';

class ChallanView extends StatefulWidget {
  const ChallanView({super.key});

  @override
  State<ChallanView> createState() => _ChallanViewState();
}

class _ChallanViewState extends State<ChallanView> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      isPadded: true,
      child: Column(
        children: [
          ///Header
          CustomHeaderWidget(
            title: AppStrings.challan.tr,
            titleIcon: AppAssets.challanIcon,
            onBackPressed: () {
              if (Get.keys[0]?.currentState?.canPop() == true) {
                Get.back(id: 0);
              }
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
