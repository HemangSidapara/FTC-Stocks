import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomHeaderWidget(
                title: AppStrings.ordersHistory.tr,
                titleIcon: AppAssets.ordersDoneIcon,
              ),
              Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: IconButton(
                  onPressed: () async {
                    await ordersHistoryController.getOrdersApiCall(isLoading: false);
                  },
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: AppColors.SECONDARY_COLOR,
                    size: 6.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),

          Expanded(
            child: Obx(() {
              if (ordersHistoryController.isGetOrdersLoading.value) {
                return const LoadingWidget();
              } else if (ordersHistoryController.orderList.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noDataFound.tr,
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR.withOpacity(0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  itemCount: ordersHistoryController.orderList.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${index + 1}. ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: ordersHistoryController.orderList[index],
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' ( ${ordersHistoryController.ordersDataList[index].category?.tr} )',
                                      style: TextStyle(
                                        color: AppColors.ORANGE_COLOR,
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                      backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      childrenPadding: EdgeInsets.only(bottom: 2.h),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Divider(
                            color: AppColors.PRIMARY_COLOR,
                            thickness: 1,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Text.rich(
                              TextSpan(
                                text: AppStrings.orderDate.tr,
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                ),
                                children: [
                                  TextSpan(
                                    text: ordersHistoryController.ordersDataList[index].datetime != null && ordersHistoryController.ordersDataList[index].datetime != '' ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(ordersHistoryController.ordersDataList[index].datetime!).toLocal()) : '-',
                                    style: TextStyle(
                                      color: AppColors.DARK_GREEN_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n${AppStrings.orderTime.tr}',
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.8,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ordersHistoryController.ordersDataList[index].datetime != null && ordersHistoryController.ordersDataList[index].datetime != '' ? DateFormat('hh:mm a').format(DateTime.parse(ordersHistoryController.ordersDataList[index].datetime!).toLocal()) : '-',
                                        style: TextStyle(
                                          color: AppColors.DARK_GREEN_COLOR,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Divider(
                            color: AppColors.PRIMARY_COLOR,
                            thickness: 1,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                          child: ListView.separated(
                            itemCount: ordersHistoryController.ordersDataList[index].modelMeta?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, innerIndex) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                                child: Column(
                                  children: [
                                    Text(
                                      '${AppStrings.size.tr} ${ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].size?.tr}',
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                    Container(
                                      color: AppColors.PRIMARY_COLOR,
                                      child: SizedBox(
                                        height: 1.5,
                                        width: 15.w,
                                      ),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text.rich(
                                      TextSpan(
                                        text: AppStrings.quantity.tr,
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.8,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].piece ?? '0',
                                            style: TextStyle(
                                              color: AppColors.DARK_GREEN_COLOR,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\n${AppStrings.weight.tr}',
                                            style: TextStyle(
                                              color: AppColors.PRIMARY_COLOR,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].weight ?? '0 kg',
                                                style: TextStyle(
                                                  color: AppColors.DARK_GREEN_COLOR,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return VerticalDivider(
                                thickness: 1,
                                color: AppColors.PRIMARY_COLOR,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 2.h);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
