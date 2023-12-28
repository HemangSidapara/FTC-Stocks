import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/add_stock_screen/add_stock_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/dropdown_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
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
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return Obx(() {
      return CustomScaffoldWidget(
        isPadded: true,
        bottomSheet: addStockController.isGetStockLoading.value
            ? null
            : ButtonWidget(
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
              child: Obx(() {
                if (addStockController.isGetStockLoading.value) {
                  return const LoadingWidget();
                } else {
                  return SingleChildScrollView(
                    child: Form(
                      key: addStockController.addStockFormKey,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: keyboardPadding != 0 ? 2.h : 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Category
                            DropDownWidget(
                              value: addStockController.selectedCategory.value == -1 ? null : addStockController.selectedCategory.value,
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
                              onChanged: (value) {
                                addStockController.selectedCategory.value = value ?? -1;
                              },
                            ),
                            SizedBox(height: 2.h),

                            ///Product
                            DropDownWidget(
                              title: AppStrings.product.tr,
                              value: addStockController.selectedProduct.value != -1 ? addStockController.selectedProduct.value : null,
                              titleChildren: [
                                TextButton(
                                  onPressed: () {
                                    addStockController.selectedCategory(-1);
                                    addStockController.selectedProduct(-1);
                                    addStockController.productNameController.clear();
                                    addStockController.selectedSizeList.clear();
                                    addStockController.customProductSizeController.clear();
                                    addStockController.resetSizeControllers();
                                  },
                                  child: Text(
                                    AppStrings.reset.tr,
                                    style: TextStyle(
                                      color: AppColors.LIGHT_BLUE_COLOR,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
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
                              onChanged: (value) {
                                addStockController.selectedProduct.value = value ?? -1;
                                addStockController.productNameController.clear();
                                if (value != null) {
                                  addStockController.selectedCategory.value = addStockController.categoryList.indexOf(addStockController.productDataList.where((p0) => p0.name == addStockController.productList[addStockController.selectedProduct.value]).toList().first.category ?? '');
                                  addStockController.selectedSizeList.clear();
                                  addStockController.selectedSizeList.addAll(addStockController.sizeList.where((element) => addStockController.productDataList.where((p0) => p0.name == addStockController.productList[addStockController.selectedProduct.value]).toList().first.modelMeta?.map((e) => e.size).toList().contains(element) == true).toList());
                                  addStockController.resetSizeControllers();

                                  for (int i = 0; i < addStockController.selectedSizeList.length; i++) {
                                    get_stock.ModelMeta? tempSizeData = addStockController.productDataList.where((p0) => p0.name == addStockController.productList[addStockController.selectedProduct.value]).toList().first.modelMeta?.where((e) => e.size == addStockController.selectedSizeList[i]).toList().firstOrNull;
                                    switch (addStockController.selectedSizeList[i]) {
                                      case '3':
                                        addStockController.sizeThreeWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        addStockController.selectedSizeThreeUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.sizeThreeQuantityController.text = tempSizeData?.piece ?? '';
                                        addStockController.sizeThreeWeightController.text = tempSizeData?.weight ?? '';
                                      case '4':
                                        addStockController.sizeFourWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        addStockController.selectedSizeFourUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.sizeFourQuantityController.text = tempSizeData?.piece ?? '';
                                        addStockController.sizeFourWeightController.text = tempSizeData?.weight ?? '';
                                      case '6':
                                        addStockController.sizeSixWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        addStockController.selectedSizeSixUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.sizeSixQuantityController.text = tempSizeData?.piece ?? '';
                                        addStockController.sizeSixWeightController.text = tempSizeData?.weight ?? '';
                                      case '8':
                                        addStockController.sizeEightWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        addStockController.selectedSizeEightUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.sizeEightQuantityController.text = tempSizeData?.piece ?? '';
                                        addStockController.sizeEightWeightController.text = tempSizeData?.weight ?? '';
                                      case '10':
                                        addStockController.sizeTenWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        addStockController.selectedSizeTenUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.sizeTenQuantityController.text = tempSizeData?.piece ?? '';
                                        addStockController.sizeTenWeightController.text = tempSizeData?.weight ?? '';
                                      case '12':
                                        addStockController.sizeTwelveWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        addStockController.selectedSizeTwelveUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.sizeTwelveQuantityController.text = tempSizeData?.piece ?? '';
                                        addStockController.sizeTwelveWeightController.text = tempSizeData?.weight ?? '';
                                      default:
                                        addStockController.sizeCustomWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        addStockController.selectedSizeCustomUnitOfWeight.value = tempSizeData?.weightOfPiece?.contains('gm') == true ? 0 : 1;
                                        addStockController.sizeCustomQuantityController.text = tempSizeData?.piece ?? '';
                                        addStockController.sizeCustomWeightController.text = tempSizeData?.weight ?? '';
                                    }
                                  }
                                }
                              },
                            ),
                            TextFieldWidget(
                              controller: addStockController.productNameController,
                              hintText: AppStrings.enterProductName.tr,
                              isDisable: addStockController.selectedProduct.value != -1,
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
                              validator: (value) {
                                return addStockController.validateProductSize(value!.toList());
                              },
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
                                          addStockController.customProductSizeController.clear();
                                          addStockController.sizeCustomQuantityController.clear();
                                          addStockController.sizeCustomWeightController.clear();
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
                                if (selectedItems.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 0.3.h),
                                    child: Text(
                                      AppStrings.selectSize.tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                } else {
                                  return SingleChildScrollView(
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
                                                        margin: EdgeInsets.only(right: 2.5.w),
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
                                }
                              },
                              selectedItems: addStockController.selectedSizeList,
                            ),
                            TextFieldWidget(
                              controller: addStockController.customProductSizeController,
                              hintText: AppStrings.enterProductSize.tr,
                              isDisable: addStockController.selectedSizeList.isNotEmpty,
                            ),
                            SizedBox(height: 2.h),

                            ///Size 3
                            if (addStockController.selectedSizeList.contains('3')) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.size3QuantityWeight.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: TextFieldWidget(
                                      controller: addStockController.sizeThreeWeightOfPieceController,
                                      hintText: AppStrings.enterWeightOfSinglePiece.tr,
                                      validator: addStockController.validateWeight,
                                      onChanged: (value) {
                                        addStockController.sizeThreeQuantityController.clear();
                                        addStockController.sizeThreeWeightController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32.w,
                                    child: DropDownWidget(
                                      value: addStockController.selectedSizeThreeUnitOfWeight.value == -1 ? null : addStockController.selectedSizeThreeUnitOfWeight.value,
                                      hintText: AppStrings.selectUnitOfWeight.tr,
                                      selectedItemBuilder: (context) {
                                        return [
                                          for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                            SizedBox(
                                              width: 22.w,
                                              child: Text(
                                                addStockController.weightUnitList[i],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.PRIMARY_COLOR,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ];
                                      },
                                      items: [
                                        for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(
                                              addStockController.weightUnitList[i],
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                      validator: addStockController.validateWeightUnit,
                                      onChanged: (value) {
                                        if (addStockController.selectedSizeThreeUnitOfWeight.value != value) {
                                          addStockController.sizeThreeQuantityController.clear();
                                          addStockController.sizeThreeWeightController.clear();
                                        }
                                        addStockController.selectedSizeThreeUnitOfWeight.value = value ?? -1;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: addStockController.sizeThreeWeightOfPieceController.text.isEmpty || addStockController.selectedSizeThreeUnitOfWeight.value == -1
                                    ? () {
                                        Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                                      }
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeThreeQuantityController,
                                        hintText: AppStrings.enterQuantity.tr,
                                        validator: (value) {
                                          return addStockController.validateQuantity(value, addStockController.sizeThreeQuantityController);
                                        },
                                        isDisable: addStockController.sizeThreeWeightOfPieceController.text.isEmpty || addStockController.selectedSizeThreeUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateWeightByQuantity(
                                            value,
                                            addStockController.sizeThreeWeightController,
                                            addStockController.sizeThreeQuantityController,
                                            addStockController.sizeThreeWeightOfPieceController,
                                            addStockController.selectedSizeThreeUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeThreeWeightController,
                                        hintText: AppStrings.enterWeight.tr,
                                        validator: addStockController.validateWeight,
                                        isDisable: addStockController.sizeThreeWeightOfPieceController.text.isEmpty || addStockController.selectedSizeThreeUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateQuantityByWeight(
                                            value,
                                            addStockController.sizeThreeQuantityController,
                                            addStockController.sizeThreeWeightController,
                                            addStockController.sizeThreeWeightOfPieceController,
                                            addStockController.selectedSizeThreeUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],

                            ///Size 4
                            if (addStockController.selectedSizeList.contains('4')) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.size4QuantityWeight.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: TextFieldWidget(
                                      controller: addStockController.sizeFourWeightOfPieceController,
                                      hintText: AppStrings.enterWeightOfSinglePiece.tr,
                                      validator: addStockController.validateWeight,
                                      onChanged: (value) {
                                        addStockController.sizeFourQuantityController.clear();
                                        addStockController.sizeFourWeightController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32.w,
                                    child: DropDownWidget(
                                      value: addStockController.selectedSizeFourUnitOfWeight.value == -1 ? null : addStockController.selectedSizeFourUnitOfWeight.value,
                                      hintText: AppStrings.selectUnitOfWeight.tr,
                                      selectedItemBuilder: (context) {
                                        return [
                                          for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                            SizedBox(
                                              width: 22.w,
                                              child: Text(
                                                addStockController.weightUnitList[i],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.PRIMARY_COLOR,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ];
                                      },
                                      items: [
                                        for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(
                                              addStockController.weightUnitList[i],
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                      validator: addStockController.validateWeightUnit,
                                      onChanged: (value) {
                                        if (addStockController.selectedSizeFourUnitOfWeight.value != value) {
                                          addStockController.sizeFourQuantityController.clear();
                                          addStockController.sizeFourWeightController.clear();
                                        }
                                        addStockController.selectedSizeFourUnitOfWeight.value = value ?? -1;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: addStockController.sizeFourWeightOfPieceController.text.isEmpty || addStockController.selectedSizeFourUnitOfWeight.value == -1
                                    ? () {
                                        Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                                      }
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeFourQuantityController,
                                        hintText: AppStrings.enterQuantity.tr,
                                        validator: (value) {
                                          return addStockController.validateQuantity(value, addStockController.sizeFourQuantityController);
                                        },
                                        isDisable: addStockController.sizeFourWeightOfPieceController.text.isEmpty || addStockController.selectedSizeFourUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateWeightByQuantity(
                                            value,
                                            addStockController.sizeFourWeightController,
                                            addStockController.sizeFourQuantityController,
                                            addStockController.sizeFourWeightOfPieceController,
                                            addStockController.selectedSizeFourUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeFourWeightController,
                                        hintText: AppStrings.enterWeight.tr,
                                        validator: addStockController.validateWeight,
                                        isDisable: addStockController.sizeFourWeightOfPieceController.text.isEmpty || addStockController.selectedSizeFourUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateQuantityByWeight(
                                            value,
                                            addStockController.sizeFourQuantityController,
                                            addStockController.sizeFourWeightController,
                                            addStockController.sizeFourWeightOfPieceController,
                                            addStockController.selectedSizeFourUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],

                            ///Size 6
                            if (addStockController.selectedSizeList.contains('6')) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.size6QuantityWeight.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: TextFieldWidget(
                                      controller: addStockController.sizeSixWeightOfPieceController,
                                      hintText: AppStrings.enterWeightOfSinglePiece.tr,
                                      validator: addStockController.validateWeight,
                                      onChanged: (value) {
                                        addStockController.sizeSixQuantityController.clear();
                                        addStockController.sizeSixWeightController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32.w,
                                    child: DropDownWidget(
                                      value: addStockController.selectedSizeSixUnitOfWeight.value == -1 ? null : addStockController.selectedSizeSixUnitOfWeight.value,
                                      hintText: AppStrings.selectUnitOfWeight.tr,
                                      selectedItemBuilder: (context) {
                                        return [
                                          for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                            SizedBox(
                                              width: 22.w,
                                              child: Text(
                                                addStockController.weightUnitList[i],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.PRIMARY_COLOR,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ];
                                      },
                                      items: [
                                        for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(
                                              addStockController.weightUnitList[i],
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                      validator: addStockController.validateWeightUnit,
                                      onChanged: (value) {
                                        if (addStockController.selectedSizeSixUnitOfWeight.value != value) {
                                          addStockController.sizeSixQuantityController.clear();
                                          addStockController.sizeSixWeightController.clear();
                                        }
                                        addStockController.selectedSizeSixUnitOfWeight.value = value ?? -1;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: addStockController.sizeSixWeightOfPieceController.text.isEmpty || addStockController.selectedSizeSixUnitOfWeight.value == -1
                                    ? () {
                                        Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                                      }
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeSixQuantityController,
                                        hintText: AppStrings.enterQuantity.tr,
                                        validator: (value) {
                                          return addStockController.validateQuantity(value, addStockController.sizeSixQuantityController);
                                        },
                                        isDisable: addStockController.sizeSixWeightOfPieceController.text.isEmpty || addStockController.selectedSizeSixUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateWeightByQuantity(
                                            value,
                                            addStockController.sizeSixWeightController,
                                            addStockController.sizeSixQuantityController,
                                            addStockController.sizeSixWeightOfPieceController,
                                            addStockController.selectedSizeSixUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeSixWeightController,
                                        hintText: AppStrings.enterWeight.tr,
                                        validator: addStockController.validateWeight,
                                        isDisable: addStockController.sizeSixWeightOfPieceController.text.isEmpty || addStockController.selectedSizeSixUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateQuantityByWeight(
                                            value,
                                            addStockController.sizeSixQuantityController,
                                            addStockController.sizeSixWeightController,
                                            addStockController.sizeSixWeightOfPieceController,
                                            addStockController.selectedSizeSixUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],

                            ///Size 8
                            if (addStockController.selectedSizeList.contains('8')) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.size8QuantityWeight.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: TextFieldWidget(
                                      controller: addStockController.sizeEightWeightOfPieceController,
                                      hintText: AppStrings.enterWeightOfSinglePiece.tr,
                                      validator: addStockController.validateWeight,
                                      onChanged: (value) {
                                        addStockController.sizeEightQuantityController.clear();
                                        addStockController.sizeEightWeightController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32.w,
                                    child: DropDownWidget(
                                      value: addStockController.selectedSizeEightUnitOfWeight.value == -1 ? null : addStockController.selectedSizeEightUnitOfWeight.value,
                                      hintText: AppStrings.selectUnitOfWeight.tr,
                                      selectedItemBuilder: (context) {
                                        return [
                                          for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                            SizedBox(
                                              width: 22.w,
                                              child: Text(
                                                addStockController.weightUnitList[i],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.PRIMARY_COLOR,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ];
                                      },
                                      items: [
                                        for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(
                                              addStockController.weightUnitList[i],
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                      validator: addStockController.validateWeightUnit,
                                      onChanged: (value) {
                                        if (addStockController.selectedSizeEightUnitOfWeight.value != value) {
                                          addStockController.sizeEightQuantityController.clear();
                                          addStockController.sizeEightWeightController.clear();
                                        }
                                        addStockController.selectedSizeEightUnitOfWeight.value = value ?? -1;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: addStockController.sizeEightWeightOfPieceController.text.isEmpty || addStockController.selectedSizeEightUnitOfWeight.value == -1
                                    ? () {
                                        Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                                      }
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeEightQuantityController,
                                        hintText: AppStrings.enterQuantity.tr,
                                        validator: (value) {
                                          return addStockController.validateQuantity(value, addStockController.sizeEightQuantityController);
                                        },
                                        isDisable: addStockController.sizeEightWeightOfPieceController.text.isEmpty || addStockController.selectedSizeEightUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateWeightByQuantity(
                                            value,
                                            addStockController.sizeEightWeightController,
                                            addStockController.sizeEightQuantityController,
                                            addStockController.sizeEightWeightOfPieceController,
                                            addStockController.selectedSizeEightUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeEightWeightController,
                                        hintText: AppStrings.enterWeight.tr,
                                        validator: addStockController.validateWeight,
                                        isDisable: addStockController.sizeEightWeightOfPieceController.text.isEmpty || addStockController.selectedSizeEightUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateQuantityByWeight(
                                            value,
                                            addStockController.sizeEightQuantityController,
                                            addStockController.sizeEightWeightController,
                                            addStockController.sizeEightWeightOfPieceController,
                                            addStockController.selectedSizeEightUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],

                            ///Size 10
                            if (addStockController.selectedSizeList.contains('10')) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.size10QuantityWeight.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: TextFieldWidget(
                                      controller: addStockController.sizeTenWeightOfPieceController,
                                      hintText: AppStrings.enterWeightOfSinglePiece.tr,
                                      validator: addStockController.validateWeight,
                                      onChanged: (value) {
                                        addStockController.sizeTenQuantityController.clear();
                                        addStockController.sizeTenWeightController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32.w,
                                    child: DropDownWidget(
                                      value: addStockController.selectedSizeTenUnitOfWeight.value == -1 ? null : addStockController.selectedSizeTenUnitOfWeight.value,
                                      hintText: AppStrings.selectUnitOfWeight.tr,
                                      selectedItemBuilder: (context) {
                                        return [
                                          for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                            SizedBox(
                                              width: 22.w,
                                              child: Text(
                                                addStockController.weightUnitList[i],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.PRIMARY_COLOR,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ];
                                      },
                                      items: [
                                        for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(
                                              addStockController.weightUnitList[i],
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                      validator: addStockController.validateWeightUnit,
                                      onChanged: (value) {
                                        addStockController.selectedSizeTenUnitOfWeight.value = value ?? -1;
                                        addStockController.sizeTenQuantityController.clear();
                                        addStockController.sizeTenWeightController.clear();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: addStockController.sizeTenWeightOfPieceController.text.isEmpty || addStockController.selectedSizeTenUnitOfWeight.value == -1
                                    ? () {
                                        Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                                      }
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeTenQuantityController,
                                        hintText: AppStrings.enterQuantity.tr,
                                        validator: (value) {
                                          return addStockController.validateQuantity(value, addStockController.sizeTenQuantityController);
                                        },
                                        isDisable: addStockController.sizeTenWeightOfPieceController.text.isEmpty || addStockController.selectedSizeTenUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateWeightByQuantity(
                                            value,
                                            addStockController.sizeTenWeightController,
                                            addStockController.sizeTenQuantityController,
                                            addStockController.sizeTenWeightOfPieceController,
                                            addStockController.selectedSizeTenUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeTenWeightController,
                                        hintText: AppStrings.enterWeight.tr,
                                        validator: addStockController.validateWeight,
                                        isDisable: addStockController.sizeTenWeightOfPieceController.text.isEmpty || addStockController.selectedSizeTenUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateQuantityByWeight(
                                            value,
                                            addStockController.sizeTenQuantityController,
                                            addStockController.sizeTenWeightController,
                                            addStockController.sizeTenWeightOfPieceController,
                                            addStockController.selectedSizeTenUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],

                            ///Size 12
                            if (addStockController.selectedSizeList.contains('12')) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.size12QuantityWeight.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: TextFieldWidget(
                                      controller: addStockController.sizeTwelveWeightOfPieceController,
                                      hintText: AppStrings.enterWeightOfSinglePiece.tr,
                                      validator: addStockController.validateWeight,
                                      onChanged: (value) {
                                        addStockController.sizeTwelveQuantityController.clear();
                                        addStockController.sizeTwelveWeightController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32.w,
                                    child: DropDownWidget(
                                      value: addStockController.selectedSizeTwelveUnitOfWeight.value == -1 ? null : addStockController.selectedSizeTwelveUnitOfWeight.value,
                                      hintText: AppStrings.selectUnitOfWeight.tr,
                                      selectedItemBuilder: (context) {
                                        return [
                                          for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                            SizedBox(
                                              width: 22.w,
                                              child: Text(
                                                addStockController.weightUnitList[i],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.PRIMARY_COLOR,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ];
                                      },
                                      items: [
                                        for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(
                                              addStockController.weightUnitList[i],
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                      validator: addStockController.validateWeightUnit,
                                      onChanged: (value) {
                                        if (addStockController.selectedSizeTwelveUnitOfWeight.value != value) {
                                          addStockController.sizeTwelveQuantityController.clear();
                                          addStockController.sizeTwelveWeightController.clear();
                                        }
                                        addStockController.selectedSizeTwelveUnitOfWeight.value = value ?? -1;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: addStockController.sizeTwelveWeightOfPieceController.text.isEmpty || addStockController.selectedSizeTwelveUnitOfWeight.value == -1
                                    ? () {
                                        Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                                      }
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeTwelveQuantityController,
                                        hintText: AppStrings.enterQuantity.tr,
                                        validator: (value) {
                                          return addStockController.validateQuantity(value, addStockController.sizeTwelveQuantityController);
                                        },
                                        isDisable: addStockController.sizeTwelveWeightOfPieceController.text.isEmpty || addStockController.selectedSizeTwelveUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateWeightByQuantity(
                                            value,
                                            addStockController.sizeTwelveWeightController,
                                            addStockController.sizeTwelveQuantityController,
                                            addStockController.sizeTwelveWeightOfPieceController,
                                            addStockController.selectedSizeTwelveUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeTwelveWeightController,
                                        hintText: AppStrings.enterWeight.tr,
                                        validator: addStockController.validateWeight,
                                        isDisable: addStockController.sizeTwelveWeightOfPieceController.text.isEmpty || addStockController.selectedSizeTwelveUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateQuantityByWeight(
                                            value,
                                            addStockController.sizeTwelveQuantityController,
                                            addStockController.sizeTwelveWeightController,
                                            addStockController.sizeTwelveWeightOfPieceController,
                                            addStockController.selectedSizeTwelveUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],

                            ///Custom Size
                            if (addStockController.isAddedCustomSize.isTrue) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.sizeCustomQuantityWeight.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 54.w,
                                    child: TextFieldWidget(
                                      controller: addStockController.sizeCustomWeightOfPieceController,
                                      hintText: AppStrings.enterWeightOfSinglePiece.tr,
                                      validator: addStockController.validateWeight,
                                      onChanged: (value) {
                                        addStockController.sizeCustomQuantityController.clear();
                                        addStockController.sizeCustomWeightController.clear();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32.w,
                                    child: DropDownWidget(
                                      value: addStockController.selectedSizeCustomUnitOfWeight.value == -1 ? null : addStockController.selectedSizeCustomUnitOfWeight.value,
                                      hintText: AppStrings.selectUnitOfWeight.tr,
                                      selectedItemBuilder: (context) {
                                        return [
                                          for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                            SizedBox(
                                              width: 22.w,
                                              child: Text(
                                                addStockController.weightUnitList[i],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.PRIMARY_COLOR,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ];
                                      },
                                      items: [
                                        for (int i = 0; i < addStockController.weightUnitList.length; i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(
                                              addStockController.weightUnitList[i],
                                              style: TextStyle(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                      ],
                                      validator: addStockController.validateWeightUnit,
                                      onChanged: (value) {
                                        if (addStockController.selectedSizeCustomUnitOfWeight.value != value) {
                                          addStockController.sizeCustomQuantityController.clear();
                                          addStockController.sizeCustomWeightController.clear();
                                        }
                                        addStockController.selectedSizeCustomUnitOfWeight.value = value ?? -1;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: addStockController.sizeCustomWeightOfPieceController.text.isEmpty || addStockController.selectedSizeCustomUnitOfWeight.value == -1
                                    ? () {
                                        Utils.validationCheck(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                                      }
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeCustomQuantityController,
                                        hintText: AppStrings.enterQuantity.tr,
                                        validator: (value) {
                                          return addStockController.validateQuantity(value, addStockController.sizeCustomQuantityController);
                                        },
                                        isDisable: addStockController.sizeCustomWeightOfPieceController.text.isEmpty || addStockController.selectedSizeCustomUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateWeightByQuantity(
                                            value,
                                            addStockController.sizeCustomWeightController,
                                            addStockController.sizeCustomQuantityController,
                                            addStockController.sizeCustomWeightOfPieceController,
                                            addStockController.selectedSizeCustomUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 43.w,
                                      child: TextFieldWidget(
                                        controller: addStockController.sizeCustomWeightController,
                                        hintText: AppStrings.enterWeight.tr,
                                        validator: addStockController.validateWeight,
                                        isDisable: addStockController.sizeCustomWeightOfPieceController.text.isEmpty || addStockController.selectedSizeCustomUnitOfWeight.value == -1,
                                        onChanged: (value) {
                                          addStockController.calculateQuantityByWeight(
                                            value,
                                            addStockController.sizeCustomQuantityController,
                                            addStockController.sizeCustomWeightController,
                                            addStockController.sizeCustomWeightOfPieceController,
                                            addStockController.selectedSizeCustomUnitOfWeight,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: keyboardPadding != 0 ? 0 : 8.h),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      );
    });
  }
}
