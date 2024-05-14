import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/total_stock_in_house_screen/total_stock_in_house_controller.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
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
                    onPressed: totalStockInHouseController.isRefreshing.value
                        ? () {}
                        : () async {
                            await totalStockInHouseController.totalStockInHouseApiCall(isLoading: false);
                          },
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
          ),

          ///Search bar
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w).copyWith(top: 0),
            child: TextFieldWidget(
              controller: totalStockInHouseController.searchTotalStockInHouseController,
              hintText: AppStrings.searchPendingOrders.tr,
              suffixIcon: totalStockInHouseController.searchTotalStockInHouseController.text.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        totalStockInHouseController.searchTotalStockInHouseController.clear();
                        Utils.unfocus();
                        await getSearchedStocksList(searchedValue: totalStockInHouseController.searchTotalStockInHouseController.text);
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
          ),

          ///Data
          Expanded(
            child: Obx(() {
              if (totalStockInHouseController.isGetStockLoading.value) {
                return const LoadingWidget();
              } else if (totalStockInHouseController.searchedStocksDataList.isEmpty) {
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
                  itemCount: totalStockInHouseController.searchedStocksDataList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ///Item Name
                          Text(
                            '${index + 1}. ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          Text(
                            totalStockInHouseController.searchedStocksDataList[index].name ?? '',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.PRIMARY_COLOR,
                            ),
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
                      childrenPadding: EdgeInsets.symmetric(horizontal: 4.w).copyWith(bottom: 2.h),
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 40.h),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                                    for (int i = 0; i < (totalStockInHouseController.searchedStocksDataList[index].modelMeta?.length ?? 0); i++)
                                      TableRow(
                                        children: [
                                          ///Size
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
                                            child: Center(
                                              child: Text(
                                                totalStockInHouseController.searchedStocksDataList[index].modelMeta?[i].size ?? '',
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
                                                totalStockInHouseController.searchedStocksDataList[index].modelMeta?[i].piece ?? '',
                                                style: TextStyle(
                                                  color: AppColors.DARK_GREEN_COLOR,
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
                                                totalStockInHouseController.searchedStocksDataList[index].modelMeta?[i].weight ?? '',
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
                            ),
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

  Future<void> getSearchedStocksList({required String searchedValue}) async {
    totalStockInHouseController.searchedStocksDataList.clear();
    if (searchedValue != "") {
      totalStockInHouseController.searchedStocksDataList.addAll(totalStockInHouseController.stocksDataList.where(
        (e) {
          return e.name?.contains(searchedValue) == true || e.name?.toLowerCase().contains(searchedValue) == true;
        },
      ).toList());
    } else {
      totalStockInHouseController.searchedStocksDataList.addAll(totalStockInHouseController.stocksDataList);
    }
  }
}
