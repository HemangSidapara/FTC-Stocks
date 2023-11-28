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
                      selectedItemBuilder: (context) {
                        return [
                          for (int i = 0; i < addStockController.categoryList.length; i++)
                            Text(
                              addStockController.categoryList[i],
                              style: TextStyle(
                                color: AppColors.PRIMARY_COLOR,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ];
                      },
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
                        constraints: BoxConstraints.loose(
                          Size(7.w, 4.5.h),
                        ),
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.3.h).copyWith(right: 1.w),
                        ),
                      ),
                      items: addStockController.sizeList,
                      popupProps: PopupPropsMultiSelection.menu(
                        menuProps: MenuProps(
                          backgroundColor: AppColors.WHITE_COLOR,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        validationWidgetBuilder: (context, item) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8),
                            child: ButtonWidget(
                              fixedSize: Size(double.maxFinite, 5.h),
                              onPressed: () {
                                setState(() {
                                  addStockController.selectedSizeList.clear();
                                  addStockController.selectedSizeList.addAll(item.map((e) => e.toString()).toList());
                                });
                                Navigator.of(context).pop();
                              },
                              buttonTitle: AppStrings.select.tr,
                            ),
                          );
                        },
                        itemBuilder: (context, item, isSelected) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                            child: Text(
                              item.toString().tr,
                              style: TextStyle(
                                color: AppColors.PRIMARY_COLOR,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          cursorColor: AppColors.PRIMARY_COLOR,
                          decoration: InputDecoration(
                            hintText: AppStrings.searchSize.tr,
                            hintStyle: TextStyle(
                              color: AppColors.HINT_GREY_COLOR,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1, color: AppColors.PRIMARY_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 1, color: AppColors.PRIMARY_COLOR),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
                          ),
                        ),
                        selectionWidget: (context, item, isSelected) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                isSelected = !isSelected;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(1.5),
                              margin: EdgeInsets.only(right: 4.w),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.PRIMARY_COLOR : AppColors.TRANSPARENT,
                                border: Border.all(
                                  color: AppColors.PRIMARY_COLOR,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: AppColors.WHITE_COLOR,
                                size: 4.3.w,
                              ),
                            ),
                          );
                        },
                      ),
                      dropdownBuilder: (context, selectedItems) {
                        selectedItems.clear();
                        selectedItems.addAll(addStockController.selectedSizeList);
                        return selectedItems.isEmpty
                            ? Text(
                                AppStrings.selectSize.tr,
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  children: selectedItems.map(
                                    (value) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedItems.removeWhere(
                                                  (element) {
                                                    return element == value;
                                                  },
                                                );
                                                addStockController.selectedSizeList.removeWhere(
                                                  (element) {
                                                    return element == value;
                                                  },
                                                );
                                              });
                                            },
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 2.w, right: 3.w, top: 0.3.h, bottom: 0.3.h),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: AppColors.PRIMARY_COLOR,
                                                    ),
                                                    margin: EdgeInsets.only(right: 2.5.w, top: 0.5.h, bottom: 0.5.h),
                                                    child: Text(
                                                      value.toString().tr,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: AppColors.WHITE_COLOR,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 2.5,
                                                  right: 1.5.w,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.WHITE_COLOR,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: AppColors.ERROR_COLOR.withOpacity(0.8),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding: const EdgeInsets.all(2),
                                                      child: Icon(
                                                        size: 2.w,
                                                        Icons.close,
                                                        color: AppColors.WHITE_COLOR,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              );
                      },
                      selectedItems: addStockController.selectedSizeList,
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
