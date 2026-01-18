import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Screens/home_screen/add_new_product_screen/add_new_product_controller.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/dropdown_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddNewProductView extends StatefulWidget {
  const AddNewProductView({super.key});

  @override
  State<AddNewProductView> createState() => _AddNewProductViewState();
}

class _AddNewProductViewState extends State<AddNewProductView> with AutomaticKeepAliveClientMixin<AddNewProductView> {
  AddNewProductController get addNewProductController => Get.find<AddNewProductController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return Obx(() {
      return CustomScaffoldWidget(
        isPadded: true,
        bottomSheet: ButtonWidget(
          onPressed: () async {
            await addNewProductController.checkAddProduct();
          },
          isLoading: addNewProductController.isAddProductLoading.value,
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: () {
            if (addNewProductController.customProductSizeController.text.trim() != '') {
              addNewProductController.customProductSizeTagsController.addTag(addNewProductController.customProductSizeController.text);
              addNewProductController.customProductSizeController.clear();
              addNewProductController.initCustomControllers();
            }
            Utils.unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Header
              CustomHeaderWidget(
                title: AppStrings.addNewProduct.tr,
                titleIcon: AppAssets.addNewProduct2Icon,
                titleIconSize: 7.w,
              ),
              SizedBox(height: 2.h),

              ///Fields
              Expanded(
                child: Obx(() {
                  if (!addNewProductController.isFormReset.value) {
                    return const LoadingWidget();
                  } else {
                    return SingleChildScrollView(
                      child: Form(
                        key: addNewProductController.addProductFormKey,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: keyboardPadding != 0 ? 2.h : 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Product
                              TextFieldWidget(
                                controller: addNewProductController.productNameController,
                                title: AppStrings.product.tr,
                                hintText: AppStrings.enterProductName.tr,
                                validator: addNewProductController.validateProduct,
                              ),
                              SizedBox(height: 2.h),

                              ///Category
                              DropDownWidget(
                                value: addNewProductController.selectedCategory.value == -1 ? null : addNewProductController.selectedCategory.value,
                                title: AppStrings.category.tr,
                                hintText: AppStrings.selectCategory.tr,
                                selectedItemBuilder: (context) {
                                  return [
                                    for (int i = 0; i < addNewProductController.categoryList.length; i++)
                                      Text(
                                        addNewProductController.categoryList[i].tr,
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ];
                                },
                                items: [
                                  for (int i = 0; i < addNewProductController.categoryList.length; i++)
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(
                                        addNewProductController.categoryList[i].tr,
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                ],
                                validator: addNewProductController.validateCategory,
                                onChanged: (value) {
                                  addNewProductController.selectedCategory.value = value ?? -1;
                                },
                              ),
                              SizedBox(height: 2.h),

                              ///Product Size
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Text(
                                  AppStrings.size.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.6.h),
                              DropdownSearch.multiSelection(
                                compareFn: (item1, item2) => item1 == item2,
                                suffixProps: DropdownSuffixProps(
                                  dropdownButtonProps: DropdownButtonProps(
                                    constraints: BoxConstraints.loose(
                                      Size(7.w, 4.5.h),
                                    ),
                                    iconOpened: Icon(
                                      Icons.keyboard_arrow_up_rounded,
                                      color: AppColors.SECONDARY_COLOR,
                                      size: 5.w,
                                    ),
                                    iconClosed: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.SECONDARY_COLOR,
                                      size: 5.w,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  return addNewProductController.validateProductSize(value!.toList());
                                },
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    filled: true,
                                    enabled: true,
                                    fillColor: AppColors.WHITE_COLOR,
                                    hintStyle: TextStyle(
                                      color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    errorStyle: TextStyle(
                                      color: AppColors.ERROR_COLOR,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
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
                                items: (filter, loadProps) {
                                  return addNewProductController.sizeList;
                                },
                                popupProps: PopupPropsMultiSelection.menu(
                                  menuProps: MenuProps(
                                    backgroundColor: AppColors.WHITE_COLOR,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  validationBuilder: (context, item) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8),
                                      child: ButtonWidget(
                                        fixedSize: Size(double.maxFinite, 5.h),
                                        onPressed: () {
                                          addNewProductController.selectedSizeList.clear();
                                          addNewProductController.selectedSizeList.addAll(item.map((e) => e.toString()).toList());
                                          Navigator.of(context).pop();
                                        },
                                        buttonTitle: AppStrings.select.tr,
                                      ),
                                    );
                                  },
                                  itemBuilder: (context, item, isDisabled, isSelected) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                      child: Text(
                                        item.toString().tr,
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR,
                                          fontSize: 14.sp,
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
                                        fontSize: 14.sp,
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
                                  checkBoxBuilder: (context, item, isDisabled, isSelected) {
                                    return AnimatedContainer(
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
                                    );
                                  },
                                ),
                                dropdownBuilder: (context, selectedItems) {
                                  selectedItems.clear();
                                  selectedItems.addAll(addNewProductController.selectedSizeList);
                                  if (selectedItems.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.only(top: 0.3.h),
                                      child: Text(
                                        AppStrings.selectSize.tr,
                                        style: TextStyle(
                                          color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
                                          fontSize: 14.sp,
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
                                                    selectedItems.removeWhere(
                                                      (element) {
                                                        return element == value;
                                                      },
                                                    );
                                                    addNewProductController.selectedSizeList.removeWhere(
                                                      (element) {
                                                        return element == value;
                                                      },
                                                    );
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
                                                              fontSize: 14.sp,
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
                                                              color: AppColors.ERROR_COLOR.withValues(alpha: 0.8),
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
                                                      ),
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
                                selectedItems: addNewProductController.selectedSizeList,
                              ),
                              TextFieldTags(
                                textfieldTagsController: addNewProductController.customProductSizeTagsController,
                                textEditingController: addNewProductController.customProductSizeController,
                                inputFieldBuilder: (context, textFieldTagValues) {
                                  return TextFieldWidget(
                                    controller: addNewProductController.customProductSizeTagsController.getTextEditingController,
                                    focusNode: addNewProductController.customProductSizeTagsController.getFocusNode,
                                    hintText: addNewProductController.customProductSizeTagsController.getTags?.isNotEmpty == true ? '' : AppStrings.enterProductSize.tr,
                                    onTap: () {
                                      addNewProductController.customProductSizeController.clear();
                                    },
                                    prefixIconConstraints: BoxConstraints(maxWidth: 75.w),
                                    prefixIcon: addNewProductController.customProductSizeTagsController.getTags?.isNotEmpty == true
                                        ? Padding(
                                            padding: EdgeInsets.only(left: 3.w),
                                            child: SingleChildScrollView(
                                              controller: addNewProductController.customProductSizeTagsController.getScrollController,
                                              scrollDirection: Axis.vertical,
                                              child: Wrap(
                                                children: addNewProductController.customProductSizeTagsController.getTags!.map(
                                                  (tag) {
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            addNewProductController.deletingCustomControllers(tag: tag);
                                                            addNewProductController.customProductSizeTagsController.onTagRemoved(tag);
                                                            if (addNewProductController.customProductSizeTagsController.getTags!.length <= 1) {
                                                              addNewProductController.isAddedCustomSize(false);
                                                            }
                                                          },
                                                          child: Stack(
                                                            alignment: Alignment.centerLeft,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment.center,
                                                                child: Container(
                                                                  padding: EdgeInsets.only(left: 1.2.w, right: 2.w, top: 0.3.h, bottom: 0.3.h),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    color: AppColors.PRIMARY_COLOR,
                                                                  ),
                                                                  margin: EdgeInsets.only(right: 2.5.w, top: 0.5.h, bottom: 0.5.h),
                                                                  child: Text(
                                                                    tag,
                                                                    textAlign: TextAlign.end,
                                                                    style: TextStyle(
                                                                      color: AppColors.WHITE_COLOR,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 14.sp,
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
                                                                      color: AppColors.ERROR_COLOR.withValues(alpha: 0.8),
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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          )
                                        : null,
                                    onChanged: (value) {
                                      if (value.isNotEmpty || (addNewProductController.customProductSizeTagsController.getTags?.length ?? 0) != 0) {
                                        addNewProductController.isAddedCustomSize(true);
                                      } else {
                                        addNewProductController.isAddedCustomSize(false);
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      addNewProductController.initCustomControllers();
                                      addNewProductController.customProductSizeTagsController.onTagSubmitted(value);
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 2.h),

                              ///Size 3
                              if (addNewProductController.selectedSizeList.contains('3'))
                                SizeOfTheStock(
                                  title: AppStrings.size3QuantityWeight,
                                  weightOfPieceController: addNewProductController.sizeThreeWeightOfPieceController,
                                  quantityController: addNewProductController.sizeThreeQuantityController,
                                  weightController: addNewProductController.sizeThreeWeightController,
                                  selectedUnitOfWeight: addNewProductController.selectedSizeThreeUnitOfWeight,
                                ),

                              ///Size 4
                              if (addNewProductController.selectedSizeList.contains('4'))
                                SizeOfTheStock(
                                  title: AppStrings.size4QuantityWeight,
                                  weightOfPieceController: addNewProductController.sizeFourWeightOfPieceController,
                                  quantityController: addNewProductController.sizeFourQuantityController,
                                  weightController: addNewProductController.sizeFourWeightController,
                                  selectedUnitOfWeight: addNewProductController.selectedSizeFourUnitOfWeight,
                                ),

                              ///Size 6
                              if (addNewProductController.selectedSizeList.contains('6'))
                                SizeOfTheStock(
                                  title: AppStrings.size6QuantityWeight,
                                  weightOfPieceController: addNewProductController.sizeSixWeightOfPieceController,
                                  quantityController: addNewProductController.sizeSixQuantityController,
                                  weightController: addNewProductController.sizeSixWeightController,
                                  selectedUnitOfWeight: addNewProductController.selectedSizeSixUnitOfWeight,
                                ),

                              ///Size 8
                              if (addNewProductController.selectedSizeList.contains('8'))
                                SizeOfTheStock(
                                  title: AppStrings.size8QuantityWeight,
                                  weightOfPieceController: addNewProductController.sizeEightWeightOfPieceController,
                                  quantityController: addNewProductController.sizeEightQuantityController,
                                  weightController: addNewProductController.sizeEightWeightController,
                                  selectedUnitOfWeight: addNewProductController.selectedSizeEightUnitOfWeight,
                                ),

                              ///Size 10
                              if (addNewProductController.selectedSizeList.contains('10'))
                                SizeOfTheStock(
                                  title: AppStrings.size10QuantityWeight,
                                  weightOfPieceController: addNewProductController.sizeTenWeightOfPieceController,
                                  quantityController: addNewProductController.sizeTenQuantityController,
                                  weightController: addNewProductController.sizeTenWeightController,
                                  selectedUnitOfWeight: addNewProductController.selectedSizeTenUnitOfWeight,
                                ),

                              ///Size 12
                              if (addNewProductController.selectedSizeList.contains('12'))
                                SizeOfTheStock(
                                  title: AppStrings.size12QuantityWeight,
                                  weightOfPieceController: addNewProductController.sizeTwelveWeightOfPieceController,
                                  quantityController: addNewProductController.sizeTwelveQuantityController,
                                  weightController: addNewProductController.sizeTwelveWeightController,
                                  selectedUnitOfWeight: addNewProductController.selectedSizeTwelveUnitOfWeight,
                                ),

                              ///Custom Size
                              if (addNewProductController.isAddedCustomSize.isTrue && addNewProductController.customProductSizeTagsController.getTags?.isNotEmpty == true)
                                for (int i = 0; i < (addNewProductController.customProductSizeTagsController.getTags?.length ?? 0); i++) ...[
                                  CustomSizeOfTheStock(
                                    title: addNewProductController.customProductSizeTagsController.getTags?[i] ?? '',
                                    weightOfPieceController: addNewProductController.sizeCustomWeightOfPieceControllerList[i],
                                    quantityController: addNewProductController.sizeCustomQuantityControllerList[i],
                                    weightController: addNewProductController.sizeCustomWeightControllerList[i],
                                    selectedUnitOfWeight: addNewProductController.selectedSizeCustomUnitOfWeightList[i],
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
        ),
      );
    });
  }

  Widget SizeOfTheStock({
    required String title,
    required TextEditingController weightOfPieceController,
    required TextEditingController quantityController,
    required TextEditingController weightController,
    required RxInt selectedUnitOfWeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(
            title.tr,
            style: TextStyle(
              color: AppColors.PRIMARY_COLOR,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 0.6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 54.w,
              child: TextFieldWidget(
                controller: weightOfPieceController,
                hintText: AppStrings.enterWeightOfSinglePiece.tr,
                validator: addNewProductController.validateWeight,
                onChanged: (value) {
                  quantityController.clear();
                  weightController.clear();
                },
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 34.w,
              child: DropDownWidget(
                value: selectedUnitOfWeight.value == -1 ? null : selectedUnitOfWeight.value,
                hintText: AppStrings.selectUnitOfWeight.tr,
                selectedItemBuilder: (context) {
                  return [
                    for (int i = 0; i < addNewProductController.weightUnitList.length; i++)
                      SizedBox(
                        width: 22.w,
                        child: Text(
                          addNewProductController.weightUnitList[i].tr,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ];
                },
                items: [
                  for (int i = 0; i < addNewProductController.weightUnitList.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text(
                        addNewProductController.weightUnitList[i].tr,
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                ],
                validator: addNewProductController.validateWeightUnit,
                onChanged: (value) {
                  if (selectedUnitOfWeight.value != value) {
                    quantityController.clear();
                    weightController.clear();
                  }
                  selectedUnitOfWeight.value = value ?? -1;
                },
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1
              ? () {
                  Utils.handleMessage(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                }
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 43.w,
                child: TextFieldWidget(
                  controller: quantityController,
                  hintText: AppStrings.enterQuantity.tr,
                  validator: (value) {
                    return addNewProductController.validateQuantity(value, quantityController);
                  },
                  isDisable: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1,
                  onChanged: (value) {
                    addNewProductController.calculateWeightByQuantity(
                      value,
                      weightController,
                      quantityController,
                      weightOfPieceController,
                      selectedUnitOfWeight,
                    );
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 43.w,
                child: TextFieldWidget(
                  controller: weightController,
                  hintText: AppStrings.enterWeight.tr,
                  validator: addNewProductController.validateWeight,
                  isDisable: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1,
                  onChanged: (value) {
                    addNewProductController.calculateQuantityByWeight(
                      value,
                      quantityController,
                      weightController,
                      weightOfPieceController,
                      selectedUnitOfWeight,
                    );
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget CustomSizeOfTheStock({
    required String title,
    required TextEditingController weightOfPieceController,
    required TextEditingController quantityController,
    required TextEditingController weightController,
    required RxInt selectedUnitOfWeight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text.rich(
            TextSpan(
              text: '${AppStrings.size.tr} ',
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: title.tr,
                  style: TextStyle(
                    color: AppColors.DARK_RED_COLOR,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' ${AppStrings.quantityAndWeight.tr}',
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
                controller: weightOfPieceController,
                hintText: AppStrings.enterWeightOfSinglePiece.tr,
                validator: addNewProductController.validateWeight,
                onChanged: (value) {
                  quantityController.clear();
                  weightController.clear();
                },
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 32.w,
              child: DropDownWidget(
                value: selectedUnitOfWeight.value == -1 ? null : selectedUnitOfWeight.value,
                hintText: AppStrings.selectUnitOfWeight.tr,
                selectedItemBuilder: (context) {
                  return [
                    for (int i = 0; i < addNewProductController.weightUnitList.length; i++)
                      SizedBox(
                        width: 22.w,
                        child: Text(
                          addNewProductController.weightUnitList[i].tr,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ];
                },
                items: [
                  for (int i = 0; i < addNewProductController.weightUnitList.length; i++)
                    DropdownMenuItem(
                      value: i,
                      child: Text(
                        addNewProductController.weightUnitList[i].tr,
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                ],
                validator: addNewProductController.validateWeightUnit,
                onChanged: (value) {
                  if (selectedUnitOfWeight.value != value) {
                    quantityController.clear();
                    weightController.clear();
                  }
                  selectedUnitOfWeight.value = value ?? -1;
                },
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1
              ? () {
                  Utils.handleMessage(message: AppStrings.firstEnterWeightOfSinglePieceAndUnitOfWeight.tr, isWarning: true);
                }
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 43.w,
                child: TextFieldWidget(
                  controller: quantityController,
                  hintText: AppStrings.enterQuantity.tr,
                  validator: (value) {
                    return addNewProductController.validateQuantity(value, quantityController);
                  },
                  isDisable: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1,
                  onChanged: (value) {
                    addNewProductController.calculateWeightByQuantity(
                      value,
                      weightController,
                      quantityController,
                      weightOfPieceController,
                      selectedUnitOfWeight,
                    );
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 43.w,
                child: TextFieldWidget(
                  controller: weightController,
                  hintText: AppStrings.enterWeight.tr,
                  validator: addNewProductController.validateWeight,
                  isDisable: weightOfPieceController.text.isEmpty || selectedUnitOfWeight.value == -1,
                  onChanged: (value) {
                    addNewProductController.calculateQuantityByWeight(
                      value,
                      quantityController,
                      weightController,
                      weightOfPieceController,
                      selectedUnitOfWeight,
                    );
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
