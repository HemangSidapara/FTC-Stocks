import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/total_stock_in_house_screen/total_stock_in_house_controller.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TotalStockInHouseView extends StatefulWidget {
  const TotalStockInHouseView({super.key});

  @override
  State<TotalStockInHouseView> createState() => _TotalStockInHouseViewState();
}

class _TotalStockInHouseViewState extends State<TotalStockInHouseView> {
  TotalStockInHouseController totalStockInHouseController = Get.put(TotalStockInHouseController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      isPadded: true,
      child: Column(
        children: [
          ///Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomHeaderWidget(
                title: AppStrings.totalStockInHouse.tr,
                titleIcon: AppAssets.totalStockInHouseIcon,
                onBackPressed: () {
                  if (Get.keys[0]?.currentState?.canPop() == true) {
                    Get.back(id: 0, closeOverlays: true);
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: IconButton(
                  onPressed: totalStockInHouseController.isRefreshing.value ? () {} : () async {},
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  icon: Obx(() {
                    return TweenAnimationBuilder(
                      duration: Duration(seconds: totalStockInHouseController.isRefreshing.value ? 45 : 1),
                      tween: Tween(begin: 0.0, end: totalStockInHouseController.isRefreshing.value ? 45.0 : totalStockInHouseController.ceilValueForRefresh.value),
                      onEnd: () {
                        totalStockInHouseController.isRefreshing.value = false;
                      },
                      builder: (context, value, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          totalStockInHouseController.ceilValueForRefresh(value.toDouble().ceilToDouble());
                        });
                        return Transform.rotate(
                          angle: value * 2 * 3.141592653589793,
                          child: Icon(
                            Icons.refresh_rounded,
                            color: AppColors.SECONDARY_COLOR,
                            size: 6.w,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
