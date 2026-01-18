import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:ftc_stocks/Network/services/utils_service/download_service.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/loading_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class ChallanView extends GetView<ChallanController> {
  const ChallanView({super.key});

  ChallanController get challanController => controller;

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
                  title: AppStrings.challan.tr,
                  titleIcon: AppAssets.challanIcon,
                  onBackPressed: () {
                    if (Get.keys[0]?.currentState?.canPop() == true) {
                      Get.back(id: 0, closeOverlays: true);
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: IconButton(
                    onPressed: challanController.isRefreshing.value
                        ? () {}
                        : () async {
                            await challanController.getCompletedOrdersApiCall(isLoading: false);
                          },
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    ),
                    icon: Obx(() {
                      return TweenAnimationBuilder(
                        duration: Duration(seconds: challanController.isRefreshing.value ? 45 : 1),
                        tween: Tween(begin: 0.0, end: challanController.isRefreshing.value ? 45.0 : challanController.ceilValueForRefresh.value),
                        onEnd: () {
                          challanController.isRefreshing.value = false;
                        },
                        builder: (context, value, child) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            challanController.ceilValueForRefresh(value.toDouble().ceilToDouble());
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
              controller: challanController.searchPartyController,
              hintText: AppStrings.searchParty.tr,
              suffixIcon: challanController.searchPartyController.text.isNotEmpty
                  ? InkWell(
                      onTap: () async {
                        challanController.searchPartyController.clear();
                        Utils.unfocus();
                        await getSearchedCompletedOrderList(searchedValue: challanController.searchPartyController.text);
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
                await getSearchedCompletedOrderList(searchedValue: value);
              },
            ),
          ),

          ///Data
          Expanded(
            child: Obx(() {
              if (challanController.isGetOrdersLoading.value) {
                return const LoadingWidget();
              } else if (challanController.searchedCompetedOrdersDataList.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noDataFound.tr,
                    style: TextStyle(
                      color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  itemCount: challanController.searchedCompetedOrdersDataList.length,
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
                            challanController.searchedCompetedOrdersDataList[index].partyName ?? '',
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
                                    text: challanController.searchedCompetedOrdersDataList[index].phone,
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

                        ///Date
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                                    text: challanController.searchedCompetedOrdersDataList[index].datetime != null && challanController.searchedCompetedOrdersDataList[index].datetime != '' ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(challanController.searchedCompetedOrdersDataList[index].datetime!).toLocal()) : '-',
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
                                        text: challanController.searchedCompetedOrdersDataList[index].datetime != null && challanController.searchedCompetedOrdersDataList[index].datetime != '' ? DateFormat('hh:mm a').format(DateTime.parse(challanController.searchedCompetedOrdersDataList[index].datetime!).toLocal()) : '-',
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
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Divider(
                            color: AppColors.PRIMARY_COLOR,
                            thickness: 1,
                          ),
                        ),

                        if (challanController.searchedCompetedOrdersDataList[index].modelMeta?.isEmpty == true)
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
                              itemCount: challanController.searchedCompetedOrdersDataList[index].modelMeta?.length ?? 0,
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
                                                challanController.searchedCompetedOrdersDataList[index].modelMeta?[productIndex].name ?? '',
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
                                  collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                  backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  childrenPadding: EdgeInsets.only(bottom: 2.h),
                                  children: [
                                    if (challanController.searchedCompetedOrdersDataList[index].modelMeta?.isEmpty == true)
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
                                          itemCount: challanController.searchedCompetedOrdersDataList[index].modelMeta?[productIndex].orderMeta?.length ?? 0,
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
                                                            "${AppStrings.size.tr}: ${challanController.searchedCompetedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].size ?? ''}",
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
                                              trailing: ElevatedButton(
                                                onPressed: () async {
                                                  await showChallanBottomSheet(
                                                    pdfUrl: challanController.searchedCompetedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].invoice ?? '',
                                                    fileName: "${challanController.searchedCompetedOrdersDataList[index].partyName?.replaceAll(' ', '')}_${challanController.searchedCompetedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].size?.replaceAll(' ', '')}.pdf",
                                                    contactNumber: challanController.searchedCompetedOrdersDataList[index].phone ?? '',
                                                  );
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
                                                child: Icon(
                                                  Icons.download_rounded,
                                                  color: AppColors.WHITE_COLOR,
                                                  size: 4.5.w,
                                                ),
                                              ),
                                              collapsedBackgroundColor: AppColors.SECONDARY_COLOR.withValues(alpha: 0.13),
                                              backgroundColor: AppColors.SECONDARY_COLOR.withValues(alpha: 0.13),
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
                                                          challanController.searchedCompetedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].piece ?? "",
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
                                                          challanController.searchedCompetedOrdersDataList[index].modelMeta?[productIndex].orderMeta?[sizeIndex].weight ?? "",
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

  Future<void> getSearchedCompletedOrderList({required String searchedValue}) async {
    challanController.searchedCompetedOrdersDataList.clear();
    if (searchedValue != "") {
      challanController.searchedCompetedOrdersDataList.addAll(
        challanController.competedOrdersDataList.where(
          (e) {
            return e.partyName?.contains(searchedValue) == true || e.partyName?.toLowerCase().contains(searchedValue) == true;
          },
        ).toList(),
      );
    } else {
      challanController.searchedCompetedOrdersDataList.addAll(challanController.competedOrdersDataList);
    }
  }

  Future<void> showChallanBottomSheet({
    required String pdfUrl,
    required String fileName,
    required String contactNumber,
  }) async {
    await showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxWidth: 100.w, minWidth: 100.w, maxHeight: 95.h, minHeight: 0.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.WHITE_COLOR,
      barrierColor: AppColors.TRANSPARENT,
      builder: (context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Back & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Title
                    Text(
                      AppStrings.viewChallan.tr,
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),

                    ///Back
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.PRIMARY_COLOR,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: AppColors.HINT_GREY_COLOR,
                  thickness: 1,
                ),
                SizedBox(height: 3.h),

                ///Viewer
                Flexible(
                  child: SfPdfViewerTheme(
                    data: SfPdfViewerThemeData(
                      backgroundColor: AppColors.WHITE_COLOR,
                      progressBarColor: AppColors.DARK_GREEN_COLOR,
                    ),
                    child: SfPdfViewer.network(
                      pdfUrl,
                      onDocumentLoadFailed: (details) {
                        debugPrint("SfPdfViewer error :: ${details.description}");
                        Utils.handleMessage(message: details.description, isError: true);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Download
                    ElevatedButton(
                      onPressed: () async {
                        await Get.put(DownloaderService()).fileDownloadService(
                          url: pdfUrl,
                          fileName: fileName,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.DARK_GREEN_COLOR,
                        fixedSize: Size(35.w, 5.h),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(
                        Icons.download_rounded,
                        color: AppColors.WHITE_COLOR,
                        size: 6.w,
                      ),
                    ),

                    ///Share
                    ElevatedButton(
                      onPressed: () async {
                        final isExist = await WhatsappShare.isInstalled();
                        if (isExist == true) {
                          final cacheFile = await Get.put(DownloaderService()).fileDownloadService(
                            url: pdfUrl,
                            fileName: fileName,
                            showLoader: false,
                          );
                          if (cacheFile != null) {
                            await WhatsappShare.shareFile(
                              phone: '91$contactNumber',
                              filePath: [cacheFile.path],
                            );
                          }
                        } else {
                          Utils.handleMessage(message: AppStrings.whatsappNotInstalled.tr, isWarning: true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.LIGHT_BLUE_COLOR,
                        fixedSize: Size(35.w, 5.h),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: AppColors.WHITE_COLOR,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
