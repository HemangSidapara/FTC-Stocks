import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/pending_orders_screen/pending_orders_controller.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({super.key});

  @override
  State<PendingOrdersView> createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  PendingOrdersController pendingOrdersController = Get.find<PendingOrdersController>();

  @override
  void initState() {
    super.initState();
    pendingOrdersController.searchPendingOrdersController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      isPadded: false,
      child: Column(
        children: [
          ///Header
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomHeaderWidget(
                  title: AppStrings.pendingOrders.tr,
                  titleIcon: AppAssets.pendingOrderIcon,
                  onBackPressed: () {
                    if (Get.keys[0]?.currentState?.canPop() == true) {
                      Get.back(id: 0, closeOverlays: true);
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: IconButton(
                    onPressed: pendingOrdersController.isRefreshing.value
                        ? () {}
                        : () async {
                            await pendingOrdersController.getOrdersApiCall(isLoading: false);
                          },
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                    icon: Obx(() {
                      return TweenAnimationBuilder(
                        duration: Duration(seconds: pendingOrdersController.isRefreshing.value ? 45 : 1),
                        tween: Tween(begin: 0.0, end: pendingOrdersController.isRefreshing.value ? 45.0 : pendingOrdersController.ceilValueForRefresh.value),
                        onEnd: () {
                          pendingOrdersController.isRefreshing.value = false;
                        },
                        builder: (context, value, child) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            pendingOrdersController.ceilValueForRefresh(value.toDouble().ceilToDouble());
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
          ),

          ///Search bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w).copyWith(top: 0),
            child: TextFieldWidget(
              controller: pendingOrdersController.searchPendingOrdersController,
              hintText: AppStrings.searchPendingOrders.tr,
              suffixIcon: pendingOrdersController.searchPendingOrdersController.text.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        pendingOrdersController.searchPendingOrdersController.clear();
                        Utils.unfocus();
                        await getSearchedOrderList(searchedValue: pendingOrdersController.searchPendingOrdersController.text);
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
                await getSearchedOrderList(searchedValue: value);
              },
            ),
          ),

          ///Data
          Expanded(
            child: Obx(() {
              if (pendingOrdersController.isGetOrdersLoading.value) {
                return const LoadingWidget();
              } else if (pendingOrdersController.searchedOrdersDataList.isEmpty) {
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
                  itemCount: pendingOrdersController.searchedOrdersDataList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ///Party Name
                          Text(
                            '${index + 1}. ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          Text(
                            pendingOrdersController.searchedOrdersDataList[index].partyName ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                        ],
                      ),
                      collapsedBackgroundColor: AppColors.WHITE_COLOR,
                      backgroundColor: AppColors.WHITE_COLOR,
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      childrenPadding: EdgeInsets.only(bottom: 2.h),
                      tilePadding: EdgeInsets.symmetric(horizontal: 5.w),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Divider(
                            color: AppColors.PRIMARY_COLOR,
                            thickness: 1,
                          ),
                        ),

                        ///Phone Number
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                                    text: pendingOrdersController.searchedOrdersDataList[index].phone,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Divider(
                            color: AppColors.PRIMARY_COLOR,
                            thickness: 1,
                          ),
                        ),

                        if (pendingOrdersController.searchedOrdersDataList[index].modelMeta?.isEmpty == true)
                          SizedBox(
                            height: 4.h,
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
                            constraints: BoxConstraints(minHeight: 0, maxHeight: 50.h),
                            child: ListView.separated(
                              itemCount: pendingOrdersController.searchedOrdersDataList[index].modelMeta?.length ?? 0,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              itemBuilder: (context, productIndex) {
                                return ExpansionTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Item Name
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
                                                pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].name ?? '',
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
                                  collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                                  backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  childrenPadding: EdgeInsets.only(bottom: 2.h),
                                  children: [
                                    if (pendingOrdersController.searchedOrdersDataList[index].modelMeta?.isEmpty == true)
                                      SizedBox(
                                        height: 6.h,
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
                                        constraints: BoxConstraints(maxHeight: 40.h, minHeight: 0),
                                        child: ListView.separated(
                                          itemCount: pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?.length ?? 0,
                                          shrinkWrap: true,
                                          itemBuilder: (context, sizeIndex) {
                                            return ExpansionTile(
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ///Size
                                                  Flexible(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '✤ ',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w700,
                                                            color: AppColors.PRIMARY_COLOR,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            "${AppStrings.size.tr}: ${pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].size ?? ''}",
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
                                              tilePadding: EdgeInsets.only(left: 5.w, right: 3.w),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ///Cancel
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await pendingOrdersController.cancelOrderApiCall(metaId: pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].metaId ?? '');
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors.DARK_RED_COLOR,
                                                      maximumSize: Size(7.5.w, 7.5.w),
                                                      minimumSize: Size(7.5.w, 7.5.w),
                                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(99),
                                                      ),
                                                      elevation: 4,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: pendingOrdersController.isCompleteOrderLoading.isFalse && pendingOrdersController.completeId.value == pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].metaId
                                                        ? Padding(
                                                            padding: EdgeInsets.all(2.w),
                                                            child: CircularProgressIndicator(
                                                              color: AppColors.WHITE_COLOR,
                                                              strokeWidth: 1.5,
                                                            ),
                                                          )
                                                        : Icon(
                                                            Icons.delete_forever_rounded,
                                                            color: AppColors.WHITE_COLOR,
                                                            size: 4.5.w,
                                                          ),
                                                  ),
                                                  SizedBox(width: 3.w),

                                                  ///Complete
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await pendingOrdersController.completeOrderApiCall(metaId: pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].metaId ?? '');
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors.DARK_GREEN_COLOR,
                                                      maximumSize: Size(7.5.w, 7.5.w),
                                                      minimumSize: Size(7.5.w, 7.5.w),
                                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(99),
                                                      ),
                                                      elevation: 4,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: pendingOrdersController.isCompleteOrderLoading.isFalse && pendingOrdersController.cancelId.value == pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].metaId
                                                        ? Padding(
                                                            padding: EdgeInsets.all(2.w),
                                                            child: CircularProgressIndicator(
                                                              color: AppColors.WHITE_COLOR,
                                                              strokeWidth: 1.5,
                                                            ),
                                                          )
                                                        : Icon(
                                                            Icons.done_rounded,
                                                            color: AppColors.WHITE_COLOR,
                                                            size: 4.5.w,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                              collapsedBackgroundColor: AppColors.SECONDARY_COLOR.withOpacity(0.13),
                                              backgroundColor: AppColors.SECONDARY_COLOR.withOpacity(0.13),
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(color: AppColors.TRANSPARENT),
                                              ),
                                              childrenPadding: EdgeInsets.only(bottom: 2.h),
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    ///Quantity
                                                    Row(
                                                      children: [
                                                        Text(
                                                          AppStrings.quantity.tr,
                                                          style: TextStyle(
                                                            color: AppColors.DARK_GREEN_COLOR,
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].piece ?? "",
                                                          style: TextStyle(
                                                            color: AppColors.DARK_RED_COLOR,
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    ///Weight
                                                    Row(
                                                      children: [
                                                        Text(
                                                          AppStrings.weight.tr,
                                                          style: TextStyle(
                                                            color: AppColors.DARK_GREEN_COLOR,
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          pendingOrdersController.searchedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].weight ?? "",
                                                          style: TextStyle(
                                                            color: AppColors.DARK_RED_COLOR,
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.w600,
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
                                            return SizedBox(height: 1.5.h);
                                          },
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
                    return SizedBox(height: 2.h);
                  },
                );
              }
            }),
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Future<void> getSearchedOrderList({required String searchedValue}) async {
    pendingOrdersController.searchedOrdersDataList.clear();
    if (searchedValue != "") {
      pendingOrdersController.searchedOrdersDataList.addAll(pendingOrdersController.ordersDataList.where(
        (e) {
          return e.partyName?.contains(searchedValue) == true || e.partyName?.toLowerCase().contains(searchedValue) == true;
        },
      ).toList());
    } else {
      pendingOrdersController.searchedOrdersDataList.addAll(pendingOrdersController.ordersDataList);
    }
  }
}
