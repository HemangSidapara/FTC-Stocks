// ignore_for_file: non_constant_identifier_names
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Network/models/add_stock_models/get_stock_model.dart' as get_stock;
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_controller.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({super.key});

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  CreateOrderController createOrderController = Get.find<CreateOrderController>();

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return Obx(() {
      return CustomScaffoldWidget(
        isPadded: true,
        bottomSheet: createOrderController.isGetStockLoading.value
            ? null
            : ButtonWidget(
                onPressed: createOrderController.isAddOrderLoading.value
                    ? () {}
                    : () async {
                        await createOrderController.checkAddOrder();
                      },
                isLoading: createOrderController.isAddOrderLoading.value,
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
        child: Column(
          children: [
            ///Header
            CustomHeaderWidget(
              title: AppStrings.createOrder.tr,
              titleIcon: AppAssets.createOrderImage,
              onBackPressed: () {
                if (Get.keys[0]?.currentState?.canPop() == true) {
                  Get.back(id: 0, closeOverlays: true);
                }
              },
            ),
            SizedBox(height: 2.h),

            ///Fields
            Expanded(
              child: Obx(() {
                if (createOrderController.isGetStockLoading.value) {
                  return const LoadingWidget();
                } else {
                  return SingleChildScrollView(
                    child: Form(
                      key: createOrderController.createOrderFormKey,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: keyboardPadding != 0 ? 2.h : 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Party Name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Text(
                                    AppStrings.partyName.tr,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    createOrderController.createOrderFormKey.currentState?.reset();
                                    createOrderController.selectedParty(-1);
                                    createOrderController.partyNameController.clear();
                                    createOrderController.phoneNumberController.clear();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    AppStrings.reset.tr,
                                    style: TextStyle(
                                      color: AppColors.LIGHT_BLUE_COLOR,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DropdownSearch<String>(
                              items: (filter, loadProps) async {
                                return await createOrderController.getPartiesApiCall(isLoading: false);
                              },
                              selectedItem: createOrderController.selectedParty.value == -1 ? null : createOrderController.partyNameList[createOrderController.selectedParty.value],
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
                              validator: createOrderController.validateParty,
                              decoratorProps: DropDownDecoratorProps(
                                baseStyle: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  enabled: true,
                                  fillColor: AppColors.WHITE_COLOR,
                                  hintText: AppStrings.selectParty.tr,
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
                              popupProps: PopupProps.menu(
                                menuProps: MenuProps(
                                  backgroundColor: AppColors.WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                loadingBuilder: (context, searchEntry) {
                                  return const Center(child: LoadingWidget());
                                },
                                emptyBuilder: (context, searchEntry) {
                                  return Center(
                                    child: Text(
                                      AppStrings.noDataFound.tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, isDisabled, isSelected) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            createOrderController.selectedParty.value = createOrderController.partyNameList.indexOf(item);
                                            createOrderController.partyNameController.text = item;
                                            createOrderController.phoneNumberController.text = createOrderController.partyDataList[createOrderController.selectedParty.value].phone ?? '';
                                          },
                                          style: TextButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                          ),
                                          child: Text(
                                            item.tr,
                                            style: TextStyle(
                                              color: AppColors.PRIMARY_COLOR,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                interceptCallBacks: true,
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  cursorColor: AppColors.PRIMARY_COLOR,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchParty.tr,
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
                              ),
                            ),
                            TextFieldWidget(
                              controller: createOrderController.partyNameController,
                              hintText: AppStrings.enterPartyName,
                              validator: createOrderController.validateProductName,
                              textInputAction: TextInputAction.next,
                              maxLength: 30,
                            ),
                            SizedBox(height: 1.h),

                            ///Phone number
                            TextFieldWidget(
                              controller: createOrderController.phoneNumberController,
                              title: AppStrings.phoneNumber.tr,
                              hintText: AppStrings.enterPhoneNumber.tr,
                              validator: createOrderController.validatePhoneNumber,
                              textInputAction: TextInputAction.next,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                            ),

                            ///Product
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Text(
                                    AppStrings.product.tr,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    createOrderController.selectedProduct(-1);
                                    createOrderController.categoryController.clear();
                                    createOrderController.selectedSizeList.clear();
                                    createOrderController.resetSizeControllers();
                                  },
                                  child: Text(
                                    AppStrings.reset.tr,
                                    style: TextStyle(
                                      color: AppColors.LIGHT_BLUE_COLOR,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            DropdownSearch<String>(
                              items: (filter, loadProps) async {
                                return await createOrderController.getStockApiCall(isLoading: false);
                              },
                              selectedItem: createOrderController.selectedProduct.value == -1 ? null : createOrderController.productList[createOrderController.selectedProduct.value],
                              onChanged: (value) {
                                if (value != null) {
                                  createOrderController.selectedProduct.value = createOrderController.productList.indexOf(value);
                                  createOrderController.categoryController.text = createOrderController.productDataList.where((p0) => p0.name == createOrderController.productList[createOrderController.selectedProduct.value]).toList().first.category ?? '';
                                  createOrderController.sizeList.clear();
                                  createOrderController.selectedSizeList.clear();
                                  createOrderController.customSizeList.clear();
                                  createOrderController.sizeList.addAll(createOrderController.defaultList);
                                  createOrderController.sizeList.addAll(createOrderController.productDataList.where((p0) => p0.name == createOrderController.productList[createOrderController.selectedProduct.value]).toList().first.modelMeta?.where((element) => !createOrderController.defaultList.contains(element.size)).toList().map((e) => e.size ?? '').toList() ?? []);
                                  createOrderController.customSizeList.addAll(createOrderController.productDataList.where((p0) => p0.name == createOrderController.productList[createOrderController.selectedProduct.value]).toList().first.modelMeta?.where((element) => !createOrderController.defaultList.contains(element.size)).toList().map((e) => e.size ?? '').toList() ?? []);
                                  createOrderController.selectedSizeList.addAll(createOrderController.sizeList.where((element) => createOrderController.productDataList.where((p0) => p0.name == createOrderController.productList[createOrderController.selectedProduct.value]).toList().first.modelMeta?.map((e) => e.size).toList().contains(element) == true).toList());
                                  createOrderController.resetSizeControllers();

                                  for (int i = 0; i < createOrderController.selectedSizeList.length; i++) {
                                    get_stock.ModelMeta? tempSizeData = createOrderController.productDataList.where((p0) => p0.name == createOrderController.productList[createOrderController.selectedProduct.value]).toList().first.modelMeta?.where((e) => e.size == createOrderController.selectedSizeList[i]).toList().firstOrNull;
                                    switch (createOrderController.selectedSizeList[i]) {
                                      case '3':
                                        createOrderController.sizeThreeWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        createOrderController.sizeThreeQuantityController.text = tempSizeData?.piece ?? '';
                                        createOrderController.sizeThreeWeightController.text = tempSizeData?.weight ?? '';
                                      case '4':
                                        createOrderController.sizeFourWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        createOrderController.sizeFourQuantityController.text = tempSizeData?.piece ?? '';
                                        createOrderController.sizeFourWeightController.text = tempSizeData?.weight ?? '';
                                      case '6':
                                        createOrderController.sizeSixWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        createOrderController.sizeSixQuantityController.text = tempSizeData?.piece ?? '';
                                        createOrderController.sizeSixWeightController.text = tempSizeData?.weight ?? '';
                                      case '8':
                                        createOrderController.sizeEightWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        createOrderController.sizeEightQuantityController.text = tempSizeData?.piece ?? '';
                                        createOrderController.sizeEightWeightController.text = tempSizeData?.weight ?? '';
                                      case '10':
                                        createOrderController.sizeTenWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        createOrderController.sizeTenQuantityController.text = tempSizeData?.piece ?? '';
                                        createOrderController.sizeTenWeightController.text = tempSizeData?.weight ?? '';
                                      case '12':
                                        createOrderController.sizeTwelveWeightOfPieceController.text = tempSizeData?.weightOfPiece ?? '';
                                        createOrderController.sizeTwelveQuantityController.text = tempSizeData?.piece ?? '';
                                        createOrderController.sizeTwelveWeightController.text = tempSizeData?.weight ?? '';
                                      default:
                                        createOrderController.sizeCustomCheckboxList.add(false.obs);
                                        createOrderController.sizeCustomWeightOfPieceControllerList.add(TextEditingController(text: tempSizeData?.weightOfPiece ?? ''));
                                        createOrderController.sizeCustomQuantityControllerList.add(TextEditingController(text: tempSizeData?.piece ?? ''));
                                        createOrderController.sizeCustomWeightControllerList.add(TextEditingController(text: tempSizeData?.weight ?? ''));
                                        createOrderController.orderSizeCustomQuantityControllerList.add(TextEditingController());
                                        createOrderController.orderSizeCustomWeightControllerList.add(TextEditingController());
                                    }
                                  }
                                }
                              },
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
                              validator: createOrderController.validateProduct,
                              decoratorProps: DropDownDecoratorProps(
                                baseStyle: TextStyle(
                                  color: AppColors.PRIMARY_COLOR,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  enabled: true,
                                  fillColor: AppColors.WHITE_COLOR,
                                  hintText: AppStrings.selectProduct.tr,
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
                              popupProps: PopupProps.menu(
                                menuProps: MenuProps(
                                  backgroundColor: AppColors.WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                loadingBuilder: (context, searchEntry) {
                                  return const Center(child: LoadingWidget());
                                },
                                emptyBuilder: (context, searchEntry) {
                                  return Center(
                                    child: Text(
                                      AppStrings.noDataFound.tr,
                                      style: TextStyle(
                                        color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.5),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, isDisabled, isSelected) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                    child: Text(
                                      item.tr,
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
                                    hintText: AppStrings.searchProduct.tr,
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
                              ),
                            ),
                            SizedBox(height: 2.h),

                            ///Category
                            TextFieldWidget(
                              controller: createOrderController.categoryController,
                              title: AppStrings.category.tr,
                              hintText: AppStrings.category.tr,
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
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 0.6.h),
                            DropdownSearch.multiSelection(
                              enabled: createOrderController.selectedProduct.value != -1,
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
                              compareFn: (item1, item2) {
                                return item1 == item2;
                              },
                              validator: (value) {
                                return createOrderController.validateProductSize(value!.toList());
                              },
                              decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  filled: true,
                                  enabled: true,
                                  fillColor: AppColors.WHITE_COLOR,
                                  hintText: AppStrings.selectSize.tr,
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
                                return createOrderController.sizeList;
                              },
                              popupProps: PopupPropsMultiSelection.menu(
                                menuProps: MenuProps(
                                  backgroundColor: AppColors.WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                disabledItemFn: (item) {
                                  return !createOrderController.sizeList.where((element) => createOrderController.productDataList.where((p0) => p0.name == createOrderController.productList[createOrderController.selectedProduct.value]).toList().first.modelMeta?.map((e) => e.size).toList().contains(element) == true).toList().contains(item);
                                },
                                validationBuilder: (context, item) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8),
                                    child: ButtonWidget(
                                      fixedSize: Size(double.maxFinite, 5.h),
                                      onPressed: () {
                                        setState(() {
                                          createOrderController.selectedSizeList.clear();
                                          createOrderController.selectedSizeList.addAll(item.map((e) => e.toString()).toList());
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      buttonTitle: AppStrings.select.tr,
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, isDisabled, isSelected) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: item.toString().isNumericOnly ? 5.w : null,
                                          child: Text(
                                            item.toString().tr,
                                            style: TextStyle(
                                              color: AppColors.PRIMARY_COLOR,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        if (!createOrderController.sizeList.where((element) => createOrderController.productDataList.where((p0) => p0.name == createOrderController.productList[createOrderController.selectedProduct.value]).toList().first.modelMeta?.map((e) => e.size).toList().contains(element) == true).toList().contains(item)) ...[
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: Text(
                                              AppStrings.thisSizeOfProductNotRegistered.tr,
                                              style: TextStyle(
                                                color: AppColors.ERROR_COLOR,
                                                fontSize: 12.5.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                                searchFieldProps: TextFieldProps(
                                  cursorColor: AppColors.PRIMARY_COLOR,
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchSize.tr,
                                    hintStyle: TextStyle(
                                      color: AppColors.HINT_GREY_COLOR,
                                      fontSize: 16.sp,
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
                                selectedItems.addAll(createOrderController.selectedSizeList);
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
                                                  setState(() {
                                                    selectedItems.removeWhere(
                                                      (element) {
                                                        return element == value;
                                                      },
                                                    );
                                                    createOrderController.selectedSizeList.removeWhere(
                                                      (element) {
                                                        return element == value;
                                                      },
                                                    );
                                                    createOrderController.sizeCustomCheckboxList[createOrderController.customSizeList.indexOf(value)].value = false;
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
                              selectedItems: createOrderController.selectedSizeList,
                            ),
                            SizedBox(height: 2.h),

                            ///Size 3
                            if (createOrderController.selectedSizeList.contains('3'))
                              SizeStockDetailsWidget(
                                title: AppStrings.size3QuantityWeight,
                                isSelected: createOrderController.sizeThreeCheckbox,
                                weightOfPieceController: createOrderController.sizeThreeWeightOfPieceController,
                                quantityController: createOrderController.sizeThreeQuantityController,
                                weightController: createOrderController.sizeThreeWeightController,
                                orderQuantityController: createOrderController.orderSizeThreeQuantityController,
                                orderWeightController: createOrderController.orderSizeThreeWeightController,
                              ),

                            ///Size 4
                            if (createOrderController.selectedSizeList.contains('4'))
                              SizeStockDetailsWidget(
                                title: AppStrings.size4QuantityWeight,
                                isSelected: createOrderController.sizeFourCheckbox,
                                weightOfPieceController: createOrderController.sizeFourWeightOfPieceController,
                                quantityController: createOrderController.sizeFourQuantityController,
                                weightController: createOrderController.sizeFourWeightController,
                                orderQuantityController: createOrderController.orderSizeFourQuantityController,
                                orderWeightController: createOrderController.orderSizeFourWeightController,
                              ),

                            ///Size 6
                            if (createOrderController.selectedSizeList.contains('6'))
                              SizeStockDetailsWidget(
                                title: AppStrings.size6QuantityWeight,
                                isSelected: createOrderController.sizeSixCheckbox,
                                weightOfPieceController: createOrderController.sizeSixWeightOfPieceController,
                                quantityController: createOrderController.sizeSixQuantityController,
                                weightController: createOrderController.sizeSixWeightController,
                                orderQuantityController: createOrderController.orderSizeSixQuantityController,
                                orderWeightController: createOrderController.orderSizeSixWeightController,
                              ),

                            ///Size 8
                            if (createOrderController.selectedSizeList.contains('8'))
                              SizeStockDetailsWidget(
                                title: AppStrings.size8QuantityWeight,
                                isSelected: createOrderController.sizeEightCheckbox,
                                weightOfPieceController: createOrderController.sizeEightWeightOfPieceController,
                                quantityController: createOrderController.sizeEightQuantityController,
                                weightController: createOrderController.sizeEightWeightController,
                                orderQuantityController: createOrderController.orderSizeEightQuantityController,
                                orderWeightController: createOrderController.orderSizeEightWeightController,
                              ),

                            ///Size 10
                            if (createOrderController.selectedSizeList.contains('10'))
                              SizeStockDetailsWidget(
                                title: AppStrings.size10QuantityWeight,
                                isSelected: createOrderController.sizeTenCheckbox,
                                weightOfPieceController: createOrderController.sizeTenWeightOfPieceController,
                                quantityController: createOrderController.sizeTenQuantityController,
                                weightController: createOrderController.sizeTenWeightController,
                                orderQuantityController: createOrderController.orderSizeTenQuantityController,
                                orderWeightController: createOrderController.orderSizeTenWeightController,
                              ),

                            ///Size 12
                            if (createOrderController.selectedSizeList.contains('12'))
                              SizeStockDetailsWidget(
                                title: AppStrings.size12QuantityWeight,
                                isSelected: createOrderController.sizeTwelveCheckbox,
                                weightOfPieceController: createOrderController.sizeTwelveWeightOfPieceController,
                                quantityController: createOrderController.sizeTwelveQuantityController,
                                weightController: createOrderController.sizeTwelveWeightController,
                                orderQuantityController: createOrderController.orderSizeTwelveQuantityController,
                                orderWeightController: createOrderController.orderSizeTwelveWeightController,
                              ),

                            ///Size Custom
                            if (createOrderController.customSizeList.isNotEmpty && createOrderController.customSizeList.any((element) => createOrderController.selectedSizeList.contains(element)))
                              for (int i = 0; i < createOrderController.customSizeList.length; i++) ...[
                                if (createOrderController.selectedSizeList.contains(createOrderController.customSizeList[i]))
                                  CustomSizeStockDetailsWidget(
                                    title: createOrderController.customSizeList[i],
                                    isSelected: createOrderController.sizeCustomCheckboxList[i],
                                    weightOfPieceController: createOrderController.sizeCustomWeightOfPieceControllerList[i],
                                    quantityController: createOrderController.sizeCustomQuantityControllerList[i],
                                    weightController: createOrderController.sizeCustomWeightControllerList[i],
                                    orderQuantityController: createOrderController.orderSizeCustomQuantityControllerList[i],
                                    orderWeightController: createOrderController.orderSizeCustomWeightControllerList[i],
                                  ),
                              ],

                            ///Order of Size 3
                            if (createOrderController.sizeThreeCheckbox.isTrue)
                              OrderOfSizesWidget(
                                title: AppStrings.orderOfSize3,
                                orderQuantityController: createOrderController.orderSizeThreeQuantityController,
                                orderWeightController: createOrderController.orderSizeThreeWeightController,
                                weightOfPieceController: createOrderController.sizeThreeWeightOfPieceController,
                              ),

                            ///Order of Size 4
                            if (createOrderController.sizeFourCheckbox.isTrue)
                              OrderOfSizesWidget(
                                title: AppStrings.orderOfSize4,
                                orderQuantityController: createOrderController.orderSizeFourQuantityController,
                                orderWeightController: createOrderController.orderSizeFourWeightController,
                                weightOfPieceController: createOrderController.sizeFourWeightOfPieceController,
                              ),

                            ///Order of Size 6
                            if (createOrderController.sizeSixCheckbox.isTrue)
                              OrderOfSizesWidget(
                                title: AppStrings.orderOfSize6,
                                orderQuantityController: createOrderController.orderSizeSixQuantityController,
                                orderWeightController: createOrderController.orderSizeSixWeightController,
                                weightOfPieceController: createOrderController.sizeSixWeightOfPieceController,
                              ),

                            ///Order of Size 8
                            if (createOrderController.sizeEightCheckbox.isTrue)
                              OrderOfSizesWidget(
                                title: AppStrings.orderOfSize8,
                                orderQuantityController: createOrderController.orderSizeEightQuantityController,
                                orderWeightController: createOrderController.orderSizeEightWeightController,
                                weightOfPieceController: createOrderController.sizeEightWeightOfPieceController,
                              ),

                            ///Order of Size 10
                            if (createOrderController.sizeTenCheckbox.isTrue)
                              OrderOfSizesWidget(
                                title: AppStrings.orderOfSize10,
                                orderQuantityController: createOrderController.orderSizeTenQuantityController,
                                orderWeightController: createOrderController.orderSizeTenWeightController,
                                weightOfPieceController: createOrderController.sizeTenWeightOfPieceController,
                              ),

                            ///Order of Size 12
                            if (createOrderController.sizeTwelveCheckbox.isTrue)
                              OrderOfSizesWidget(
                                title: AppStrings.orderOfSize12,
                                orderQuantityController: createOrderController.orderSizeTwelveQuantityController,
                                orderWeightController: createOrderController.orderSizeTwelveWeightController,
                                weightOfPieceController: createOrderController.sizeTwelveWeightOfPieceController,
                              ),

                            ///Order of Size Custom
                            for (int i = 0; i < createOrderController.customSizeList.length; i++) ...[
                              if (createOrderController.selectedSizeList.isNotEmpty)
                                if (createOrderController.sizeCustomCheckboxList[i].isTrue)
                                  CustomOrderOfSizesWidget(
                                    title: createOrderController.customSizeList[i],
                                    orderQuantityController: createOrderController.orderSizeCustomQuantityControllerList[i],
                                    orderWeightController: createOrderController.orderSizeCustomWeightControllerList[i],
                                    weightOfPieceController: createOrderController.sizeCustomWeightOfPieceControllerList[i],
                                  ),
                            ],
                            SizedBox(height: 6.h),
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

  Widget SizeStockDetailsWidget({
    required String title,
    required RxBool isSelected,
    required TextEditingController weightOfPieceController,
    required TextEditingController quantityController,
    required TextEditingController weightController,
    required TextEditingController orderQuantityController,
    required TextEditingController orderWeightController,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              isSelected.toggle();
              orderQuantityController.clear();
              orderWeightController.clear();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title.tr,
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected.value ? AppColors.LIGHT_BLUE_COLOR : AppColors.WHITE_COLOR,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected.value ? AppColors.LIGHT_BLUE_COLOR : AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.WHITE_COLOR,
                      size: 3.5.w,
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
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: AppStrings.weightOfPiece.tr,
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: weightOfPieceController.text.isNotEmpty ? weightOfPieceController.text : '-',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.DARK_GREEN_COLOR,
                        ),
                      ),
                      TextSpan(
                        text: '\n${AppStrings.availableStockQuantityWeight.tr}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      TextSpan(
                        text: '${quantityController.text.isNotEmpty ? quantityController.text : '0'}${AppStrings.pieces.tr}/${weightController.text.isNotEmpty ? weightController.text : '0 kg'}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.DARK_GREEN_COLOR,
                        ),
                      ),
                    ],
                  ),
                  style: const TextStyle(height: 1.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      );
    });
  }

  Widget CustomSizeStockDetailsWidget({
    required String title,
    required RxBool isSelected,
    required TextEditingController weightOfPieceController,
    required TextEditingController quantityController,
    required TextEditingController weightController,
    required TextEditingController orderQuantityController,
    required TextEditingController orderWeightController,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              isSelected.toggle();
              orderQuantityController.clear();
              orderWeightController.clear();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
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
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected.value ? AppColors.LIGHT_BLUE_COLOR : AppColors.WHITE_COLOR,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected.value ? AppColors.LIGHT_BLUE_COLOR : AppColors.PRIMARY_COLOR,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.WHITE_COLOR,
                      size: 3.5.w,
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
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: AppStrings.weightOfPiece.tr,
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: weightOfPieceController.text.isNotEmpty ? weightOfPieceController.text : '-',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.DARK_GREEN_COLOR,
                        ),
                      ),
                      TextSpan(
                        text: '\n${AppStrings.availableStockQuantityWeight.tr}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      TextSpan(
                        text: '${quantityController.text.isNotEmpty ? quantityController.text : '0'}${AppStrings.pieces.tr}/${weightController.text.isNotEmpty ? weightController.text : '0 kg'}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.DARK_GREEN_COLOR,
                        ),
                      ),
                    ],
                  ),
                  style: const TextStyle(height: 1.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      );
    });
  }

  Widget OrderOfSizesWidget({
    required String title,
    required TextEditingController orderQuantityController,
    required TextEditingController orderWeightController,
    required TextEditingController weightOfPieceController,
  }) {
    final tempWeightOfPieceController = TextEditingController(text: weightOfPieceController.text.replaceAll(' gm', '').replaceAll(' kg', ''));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 43.w,
              child: TextFieldWidget(
                controller: orderQuantityController,
                hintText: AppStrings.enterQuantity.tr,
                keyboardType: const TextInputType.numberWithOptions(),
                validator: (value) => createOrderController.validateQuantity(value, orderQuantityController),
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  createOrderController.calculateWeightByQuantity(
                    value,
                    orderWeightController,
                    orderQuantityController,
                    tempWeightOfPieceController,
                    weightOfPieceController.text.contains('gm') == true || weightOfPieceController.text.contains('kg') == false ? 0.obs : 1.obs,
                  );
                },
              ),
            ),
            SizedBox(
              width: 43.w,
              child: TextFieldWidget(
                controller: orderWeightController,
                hintText: AppStrings.enterWeight,
                keyboardType: TextInputType.number,
                validator: (value) => createOrderController.validateWeight(value),
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  createOrderController.calculateQuantityByWeight(
                    value,
                    orderQuantityController,
                    orderWeightController,
                    tempWeightOfPieceController,
                    weightOfPieceController.text.contains('gm') == true || weightOfPieceController.text.contains('kg') == false ? 0.obs : 1.obs,
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget CustomOrderOfSizesWidget({
    required String title,
    required TextEditingController orderQuantityController,
    required TextEditingController orderWeightController,
    required TextEditingController weightOfPieceController,
  }) {
    final tempWeightOfPieceController = TextEditingController(text: weightOfPieceController.text.replaceAll(' gm', '').replaceAll(' kg', ''));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text.rich(
            TextSpan(
              text: AppStrings.orderOfSizeCustom.tr.replaceAll('Custom', '').replaceAll('કસ્ટમ', '').replaceAll('कस्टम', ''),
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
              ],
            ),
          ),
        ),
        SizedBox(height: 0.6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 43.w,
              child: TextFieldWidget(
                controller: orderQuantityController,
                hintText: AppStrings.enterQuantity.tr,
                keyboardType: TextInputType.number,
                validator: (value) => createOrderController.validateQuantity(value, orderQuantityController),
                onChanged: (value) {
                  createOrderController.calculateWeightByQuantity(
                    value,
                    orderWeightController,
                    orderQuantityController,
                    tempWeightOfPieceController,
                    weightOfPieceController.text.contains('gm') == true || weightOfPieceController.text.contains('kg') == false ? 0.obs : 1.obs,
                  );
                },
              ),
            ),
            SizedBox(
              width: 43.w,
              child: TextFieldWidget(
                controller: orderWeightController,
                hintText: AppStrings.enterWeight,
                keyboardType: TextInputType.number,
                validator: (value) => createOrderController.validateWeight(value),
                onChanged: (value) {
                  createOrderController.calculateQuantityByWeight(
                    value,
                    orderQuantityController,
                    orderWeightController,
                    tempWeightOfPieceController,
                    weightOfPieceController.text.contains('gm') == true || weightOfPieceController.text.contains('kg') == false ? 0.obs : 1.obs,
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
