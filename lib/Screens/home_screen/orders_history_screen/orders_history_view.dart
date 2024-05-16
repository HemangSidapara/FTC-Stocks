import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_controller.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
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
    return GestureDetector(
      onTap: () => Utils.unfocus(),
      child: Padding(
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
            SizedBox(height: 2.h),

            ///Search bar
            TextFieldWidget(
              controller: ordersHistoryController.searchOrderHistoryController,
              hintText: AppStrings.searchParty.tr,
              suffixIcon: ordersHistoryController.searchOrderHistoryController.text.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        ordersHistoryController.searchOrderHistoryController.clear();
                        Utils.unfocus();
                        await getSearchedStocksList(searchedValue: ordersHistoryController.searchOrderHistoryController.text);
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.SECONDARY_COLOR,
                        size: context.isPortrait ? 4.w : 4.h,
                      ),
                    )
                  : null,
              suffixIconConstraints: BoxConstraints(minWidth: context.isPortrait ? 10.w : 10.h, maxWidth: context.isPortrait ? 10.w : 10.h),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.SECONDARY_COLOR,
                size: context.isPortrait ? 4.w : 4.h,
              ),
              prefixIconConstraints: BoxConstraints(minWidth: context.isPortrait ? 10.w : 10.h, maxWidth: context.isPortrait ? 10.w : 10.h),
              onChanged: (value) async {
                await getSearchedStocksList(searchedValue: value);
              },
            ),
            SizedBox(height: 2.h),

            Expanded(
              child: Obx(() {
                if (ordersHistoryController.isGetOrdersLoading.value) {
                  return const LoadingWidget();
                } else if (ordersHistoryController.searchedOrdersDataList.isEmpty) {
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
                    itemCount: ordersHistoryController.searchedOrdersDataList.length,
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
                                  ordersHistoryController.searchedOrdersDataList[index].partyName ?? '',
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
                                      text: ordersHistoryController.searchedOrdersDataList[index].phone ?? '',
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
                                      text: ordersHistoryController.searchedOrdersDataList[index].datetime != null && ordersHistoryController.searchedOrdersDataList[index].datetime != '' ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(ordersHistoryController.searchedOrdersDataList[index].datetime!).toLocal()) : '-',
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
                                          text: ordersHistoryController.searchedOrdersDataList[index].datetime != null && ordersHistoryController.searchedOrdersDataList[index].datetime != '' ? DateFormat('hh:mm a').format(DateTime.parse(ordersHistoryController.searchedOrdersDataList[index].datetime!).toLocal()) : '-',
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
                          if (ordersHistoryController.searchedOrdersDataList[index].modelMeta?.isEmpty == true)
                            SizedBox(
                              height: 10.h,
                              child: Center(
                                child: Text(
                                  AppStrings.noDataFound.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            )
                          else
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 50.h, minHeight: 0),
                              child: ListView.separated(
                                itemCount: ordersHistoryController.searchedOrdersDataList[index].modelMeta?.length ?? 0,
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
                                                  ordersHistoryController.searchedOrdersDataList[index].modelMeta?[innerIndex].name ?? '',
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
                                    childrenPadding: EdgeInsets.symmetric(horizontal: 4.w).copyWith(bottom: 2.h),
                                    children: [
                                      Table(
                                        border: TableBorder.all(
                                          color: AppColors.PRIMARY_COLOR,
                                          width: 1,
                                        ),
                                        children: [
                                          ///Headings
                                          TableRow(
                                            children: [
                                              ///Size
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
                                                child: Center(
                                                  child: Text(
                                                    AppStrings.size.tr,
                                                    style: TextStyle(
                                                      color: AppColors.PRIMARY_COLOR,
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ///Quantity
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
                                                child: Center(
                                                  child: Text(
                                                    AppStrings.quantity.tr.replaceAll(':', ''),
                                                    style: TextStyle(
                                                      color: AppColors.PRIMARY_COLOR,
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ///Weight
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
                                                child: Center(
                                                  child: Text(
                                                    AppStrings.weight.tr.replaceAll(':', ''),
                                                    style: TextStyle(
                                                      color: AppColors.PRIMARY_COLOR,
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          ///Data
                                          for (int i = 0; i < (ordersHistoryController.searchedOrdersDataList[index].modelMeta?[innerIndex].orderMeta?.length ?? 0); i++)
                                            TableRow(
                                              children: [
                                                ///Size
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
                                                  child: Center(
                                                    child: Text(
                                                      ordersHistoryController.searchedOrdersDataList[index].modelMeta?[innerIndex].orderMeta?[i].size ?? '',
                                                      style: TextStyle(
                                                        color: AppColors.PRIMARY_COLOR,
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                ///Quantity
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
                                                  child: Center(
                                                    child: Text(
                                                      ordersHistoryController.searchedOrdersDataList[index].modelMeta?[innerIndex].orderMeta?[i].piece ?? '',
                                                      style: TextStyle(
                                                        color: AppColors.DARK_RED_COLOR,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                ///Weight
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.6.h),
                                                  child: Center(
                                                    child: Text(
                                                      ordersHistoryController.searchedOrdersDataList[index].modelMeta?[innerIndex].orderMeta?[i].weight ?? '',
                                                      style: TextStyle(
                                                        color: AppColors.DARK_GREEN_COLOR,
                                                        fontSize: 16.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
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
      ),
    );
  }

  Future<void> getSearchedStocksList({required String searchedValue}) async {
    ordersHistoryController.searchedOrdersDataList.clear();
    if (searchedValue != "") {
      ordersHistoryController.searchedOrdersDataList.addAll(ordersHistoryController.ordersDataList.where(
        (e) {
          return e.partyName?.contains(searchedValue) == true || e.partyName?.toLowerCase().contains(searchedValue) == true;
        },
      ).toList());
    } else {
      ordersHistoryController.searchedOrdersDataList.addAll(ordersHistoryController.ordersDataList);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
