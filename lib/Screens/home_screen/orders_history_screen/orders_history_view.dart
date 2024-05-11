import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_controller.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
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
                  onPressed: ordersHistoryController.isRefreshing.value
                      ? () {}
                      : () async {
                          await ordersHistoryController.getOrdersApiCall(isLoading: false);
                        },
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  ),
                  icon: Obx(() {
                    return TweenAnimationBuilder(
                      duration: Duration(seconds: ordersHistoryController.isRefreshing.value ? 45 : 1),
                      tween: Tween(begin: 0.0, end: ordersHistoryController.isRefreshing.value ? 45.0 : ordersHistoryController.ceilValueForRefresh.value),
                      onEnd: () {
                        ordersHistoryController.isRefreshing.value = false;
                      },
                      builder: (context, value, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ordersHistoryController.ceilValueForRefresh(value.toDouble().ceilToDouble());
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
                      fontSize: 16.sp,
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
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              Text(
                                ordersHistoryController.ordersDataList[index].partyName ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.PRIMARY_COLOR,
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

                        ///Phone Number
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text.rich(
                              TextSpan(
                                text: "${AppStrings.phoneNumber.tr}: ",
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: ordersHistoryController.ordersDataList[index].phone ?? '',
                                    style: TextStyle(
                                      color: AppColors.ORANGE_COLOR,
                                      fontSize: 14.5.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
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

                        ///Date
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Text.rich(
                              TextSpan(
                                text: AppStrings.orderDate.tr,
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                ),
                                children: [
                                  TextSpan(
                                    text: ordersHistoryController.ordersDataList[index].datetime != null && ordersHistoryController.ordersDataList[index].datetime != '' ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(ordersHistoryController.ordersDataList[index].datetime!).toLocal()) : '-',
                                    style: TextStyle(
                                      color: AppColors.DARK_GREEN_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n${AppStrings.orderTime.tr}',
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.8,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ordersHistoryController.ordersDataList[index].datetime != null && ordersHistoryController.ordersDataList[index].datetime != '' ? DateFormat('hh:mm a').format(DateTime.parse(ordersHistoryController.ordersDataList[index].datetime!).toLocal()) : '-',
                                        style: TextStyle(
                                          color: AppColors.DARK_GREEN_COLOR,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
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

                        ///Orders
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 50.h, minHeight: 0),
                          child: ListView.separated(
                            itemCount: ordersHistoryController.ordersDataList[index].modelMeta?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, innerIndex) {
                              return ExpansionTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ///Size
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Text(
                                            '❖ ',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.PRIMARY_COLOR,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].name ?? '',
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.PRIMARY_COLOR,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                  ],
                                ),
                                collapsedBackgroundColor: AppColors.SECONDARY_COLOR.withOpacity(0.13),
                                backgroundColor: AppColors.SECONDARY_COLOR.withOpacity(0.13),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: AppColors.TRANSPARENT),
                                ),
                                childrenPadding: EdgeInsets.only(bottom: 2.h),
                                children: [
                                  ///Headings
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Size
                                      SizedBox(
                                        width: 45.w,
                                        child: Center(
                                          child: Text(
                                            AppStrings.size.tr,
                                            style: TextStyle(
                                              color: AppColors.PRIMARY_COLOR,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ),

                                      ///Quantity & Weight
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              AppStrings.quantity.tr.replaceAll(':', ''),
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              AppStrings.weight.tr.replaceAll(':', ''),
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Divider(
                                      color: AppColors.PRIMARY_COLOR,
                                      thickness: 1,
                                    ),
                                  ),
                                  if (ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].orderMeta?.isEmpty == true)
                                    Center(
                                      child: Text(
                                        AppStrings.noDataFound.tr,
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    )
                                  else
                                    ConstrainedBox(
                                      constraints: BoxConstraints(minHeight: 0, maxHeight: 40.h),
                                      child: ListView.separated(
                                        itemCount: ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].orderMeta?.length ?? 0,
                                        shrinkWrap: true,
                                        itemBuilder: (context, sizeIndex) {
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///Size
                                              SizedBox(
                                                width: 45.w,
                                                child: Center(
                                                  child: Text(
                                                    ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].orderMeta?[sizeIndex].size ?? '',
                                                    style: TextStyle(
                                                      color: AppColors.PRIMARY_COLOR,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ///Quantity & Weight
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].orderMeta?[sizeIndex].piece ?? '',
                                                      style: TextStyle(
                                                        color: AppColors.ORANGE_COLOR,
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      ordersHistoryController.ordersDataList[index].modelMeta?[innerIndex].orderMeta?[sizeIndex].weight ?? '',
                                                      style: TextStyle(
                                                        color: AppColors.DARK_GREEN_COLOR,
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 1.5.h);
                                        },
                                      ),
                                    ),
                                ],
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
