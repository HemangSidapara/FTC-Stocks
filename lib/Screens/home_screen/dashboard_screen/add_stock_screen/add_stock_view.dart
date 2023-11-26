import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/dropdown_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';

class AddStockView extends StatefulWidget {
  const AddStockView({super.key});

  @override
  State<AddStockView> createState() => _AddStockViewState();
}

class _AddStockViewState extends State<AddStockView> {
  AddStockController addStockController = Get.find<AddStockController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      isPadded: true,
      bottomSheet: ButtonWidget(
        onPressed: () async {
          await addStockController.checkAddStock();
        },
        fixedSize: Size(double.maxFinite, 5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              size: 5.w,
              color: AppColors.WHITE_COLOR,
            ),
            SizedBox(width: 1.w),
            Text(
              AppStrings.add.tr,
              style: TextStyle(
                color: AppColors.WHITE_COLOR,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Header
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (Get.keys[0]?.currentState?.canPop() == true) {
                    Get.back(id: 0);
                  }
                },
                style: IconButton.styleFrom(
                  surfaceTintColor: AppColors.LIGHT_SECONDARY_COLOR,
                  highlightColor: AppColors.LIGHT_SECONDARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Image.asset(
                  AppAssets.backIcon,
                  width: 8.w,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                AppStrings.addStock.tr,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 2.w),
              Image.asset(
                AppAssets.addStockIcon,
                width: 8.w,
              ),
            ],
          ),
          SizedBox(height: 2.h),

          ///Fields
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: addStockController.addStockFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Category
                    DropDownWidget(
                      title: AppStrings.category.tr,
                      hintText: AppStrings.selectCategory.tr,
                      items: [
                        for (int i = 0; i < addStockController.categoryList.length; i++)
                          DropdownMenuItem(
                            value: i,
                            child: Text(
                              addStockController.categoryList[i],
                              style: TextStyle(
                                color: AppColors.PRIMARY_COLOR,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                      ],
                      validator: addStockController.validateCategory,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 2.h),

                    ///Product
                    DropDownWidget(
                      title: AppStrings.product.tr,
                      hintText: AppStrings.selectProduct.tr,
                      items: [
                        for (int i = 0; i < addStockController.productList.length; i++)
                          DropdownMenuItem(
                            value: i,
                            child: Text(
                              addStockController.productList[i],
                              style: TextStyle(
                                color: AppColors.PRIMARY_COLOR,
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                      ],
                      validator: addStockController.validateProduct,
                      onChanged: (value) {},
                    ),
                    TextFieldWidget(
                      controller: addStockController.productNameController,
                      hintText: AppStrings.enterProductName.tr,
                      isDisable: true,
                    ),
                    SizedBox(height: 2.h),

                    ///Product Size
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: Text(
                        AppStrings.size.tr,
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.6.h),
                    DropdownSearch.multiSelection(
                      dropdownButtonProps: DropdownButtonProps(
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.SECONDARY_COLOR,
                          size: 5.w,
                        ),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          enabled: true,
                          fillColor: AppColors.WHITE_COLOR,
                          hintText: AppStrings.selectSize.tr,
                          hintStyle: TextStyle(
                            color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.PRIMARY_COLOR,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.PRIMARY_COLOR,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.PRIMARY_COLOR,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.ERROR_COLOR,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.ERROR_COLOR,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h).copyWith(right: 1.5.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
