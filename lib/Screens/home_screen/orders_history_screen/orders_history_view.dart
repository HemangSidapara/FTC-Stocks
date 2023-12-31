import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:get/get.dart';

class OrdersHistoryView extends StatefulWidget {
  const OrdersHistoryView({super.key});

  @override
  State<OrdersHistoryView> createState() => _OrdersHistoryViewState();
}

class _OrdersHistoryViewState extends State<OrdersHistoryView> with AutomaticKeepAliveClientMixin {
  OrdersHistoryController ordersHistoryController = Get.find<OrdersHistoryController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Header
          Row(
            children: [
              Text(
                AppStrings.ordersHistory.tr,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 2.w),
              Image.asset(
                AppAssets.ordersDoneIcon,
                color: AppColors.PRIMARY_COLOR,
                width: 6.5.w,
              ),
            ],
          ),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
