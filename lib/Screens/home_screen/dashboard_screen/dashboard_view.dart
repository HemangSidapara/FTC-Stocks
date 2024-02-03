import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:get/get.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with AutomaticKeepAliveClientMixin {
  DashboardController dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w).copyWith(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.hello.tr,
            style: TextStyle(
              color: AppColors.PRIMARY_COLOR,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),

          ///Features
          Expanded(
            child: CustomScrollView(
              slivers: [
                ///Create Order
                if (getData(AppConstance.role) == 'Admin') ...[
                  SliverToBoxAdapter(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.toNamed(Routes.createOrderScreen, id: 0);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.LIGHT_SECONDARY_COLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 65.w,
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppAssets.createOrderImage,
                                    width: 20.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    AppStrings.createOrder.tr,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              AppAssets.frontIcon,
                              width: 9.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 2.h),
                  ),
                ],

                ///Add stocks, Total stocks, Minimum stocks and Challan
                SliverPadding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 2.h,
                    ),
                    itemCount: dashboardController.contentList.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          Get.toNamed(dashboardController.contentRouteList[index], id: 0);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.LIGHT_SECONDARY_COLOR,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h).copyWith(bottom: 0.5.h, right: 2.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    dashboardController.contentList[index].tr,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset(
                                    dashboardController.contentIconList[index],
                                    width: 14.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                ///InProgress Stock
                if (getData(AppConstance.role) == 'Admin')
                  SliverToBoxAdapter(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.toNamed(Routes.inProgressStockScreen, id: 0);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.LIGHT_SECONDARY_COLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 65.w,
                              child: Row(
                                children: [
                                  Image.asset(
                                    AppAssets.inProgressStockIcon,
                                    width: 15.w,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    AppStrings.inProgressStock.tr,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              AppAssets.frontIcon,
                              width: 9.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 2.h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
