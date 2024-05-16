import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/required_stock_screen/required_stock_controller.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RequiredStockView extends StatefulWidget {
  const RequiredStockView({super.key});

  @override
  State<RequiredStockView> createState() => _RequiredStockViewState();
}

class _RequiredStockViewState extends State<RequiredStockView> {
  RequiredStockController requiredStockController = Get.find<RequiredStockController>();

  @override
  void initState() {
    super.initState();
    requiredStockController.searchRequiredStockController.addListener(() {
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
                  title: AppStrings.requiredStock.tr,
                  titleIcon: AppAssets.requiredStockIcon,
                  onBackPressed: () {
                    if (Get.keys[0]?.currentState?.canPop() == true) {
                      Get.back(id: 0, closeOverlays: true);
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: IconButton(
                    onPressed: requiredStockController.isRefreshing.value
                        ? () {}
                        : () async {
                            await requiredStockController.getRequiredStockApiCall(isLoading: false);
                          },
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                    icon: Obx(() {
                      return TweenAnimationBuilder(
                        duration: Duration(seconds: requiredStockController.isRefreshing.value ? 45 : 1),
                        tween: Tween(begin: 0.0, end: requiredStockController.isRefreshing.value ? 45.0 : requiredStockController.ceilValueForRefresh.value),
                        onEnd: () {
                          requiredStockController.isRefreshing.value = false;
                        },
                        builder: (context, value, child) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            requiredStockController.ceilValueForRefresh(value.toDouble().ceilToDouble());
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
              controller: requiredStockController.searchRequiredStockController,
              hintText: AppStrings.searchRequiredStock.tr,
              suffixIcon: requiredStockController.searchRequiredStockController.text.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        requiredStockController.searchRequiredStockController.clear();
                        Utils.unfocus();
                        await getSearchedRequiredStockList(searchedValue: requiredStockController.searchRequiredStockController.text);
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
                await getSearchedRequiredStockList(searchedValue: value);
              },
            ),
          ),

          ///Data
          Expanded(
            child: Obx(() {
              if (requiredStockController.isGetStockLoading.value) {
                return const LoadingWidget();
              } else if (requiredStockController.searchedRequiredStockDataList.isEmpty) {
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
                  itemCount: requiredStockController.searchedRequiredStockDataList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Product Name
                          Flexible(
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}. ',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    requiredStockController.searchedRequiredStockDataList[index].name ?? '',
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

                          ///Category
                          Flexible(
                            child: Text(
                              "( ${requiredStockController.searchedRequiredStockDataList[index].category ?? ''} )",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ORANGE_COLOR,
                              ),
                            ),
                          )
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
                        if (requiredStockController.searchedRequiredStockDataList[index].modelMeta?.isEmpty == true)
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
                            constraints: BoxConstraints(maxHeight: 60.h, minHeight: 0),
                            child: ListView.separated(
                              itemCount: requiredStockController.searchedRequiredStockDataList[index].modelMeta?.length ?? 0,
                              shrinkWrap: true,
                              itemBuilder: (context, productIndex) {
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
                                                "${AppStrings.size.tr}: ${requiredStockController.searchedRequiredStockDataList[index].modelMeta?[productIndex].size ?? ''}",
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
                                              requiredStockController.searchedRequiredStockDataList[index].modelMeta?[productIndex].piece ?? "",
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
                                              requiredStockController.searchedRequiredStockDataList[index].modelMeta?[productIndex].weight ?? "",
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

  Future<void> getSearchedRequiredStockList({required String searchedValue}) async {
    requiredStockController.searchedRequiredStockDataList.clear();
    if (searchedValue != "") {
      requiredStockController.searchedRequiredStockDataList.addAll(requiredStockController.requiredStockDataList.where(
        (e) {
          return e.name?.contains(searchedValue) == true || e.name?.toLowerCase().contains(searchedValue) == true;
        },
      ).toList());
    } else {
      requiredStockController.searchedRequiredStockDataList.addAll(requiredStockController.requiredStockDataList);
    }
  }
}
