import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/pending_orders_screen/pending_orders_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:get/get.dart';

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({super.key});

  @override
  State<PendingOrdersView> createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  PendingOrdersController pendingOrdersController = Get.find<PendingOrdersController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      isPadded: true,
      child: Column(
        children: [
          ///Header
          CustomHeaderWidget(
            title: AppStrings.pendingOrders.tr,
            titleIcon: AppAssets.pendingOrderIcon,
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
