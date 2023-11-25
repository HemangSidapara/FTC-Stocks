import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:get/get.dart';

class CreateStocksView extends StatefulWidget {
  const CreateStocksView({super.key});

  @override
  State<CreateStocksView> createState() => _CreateStocksViewState();
}

class _CreateStocksViewState extends State<CreateStocksView> {
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      isPadded: true,
      child: Column(
        children: [
          ///Header
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (Get.keys[0]?.currentState?.canPop() == true) {
                    Get.back(id: 0);
                  }
                },
                style: IconButton.styleFrom(
                  surfaceTintColor: AppColors.LIGHT_SECONDARY_COLOR,
                  highlightColor: AppColors.LIGHT_SECONDARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: Image.asset(
                  AppAssets.backIcon,
                  width: 8.w,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                AppStrings.addStock.tr,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 2.w),
              Image.asset(
                AppAssets.addStockIcon,
                width: 8.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}