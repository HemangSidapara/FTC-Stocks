import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/home_controller.dart';
import 'package:ftc_stocks/Screens/home_screen/settings_screen/settings_controller.dart';
import 'package:ftc_stocks/Utils/in_app_update_dialog_widget.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_header_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with AutomaticKeepAliveClientMixin {
  SettingsController settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomHeaderWidget(
                title: AppStrings.settings.tr,
                titleIcon: AppAssets.settingsAnim,
                titleIconSize: 7.w,
              ),
              Obx(() {
                return Row(
                  children: [
                    if (Get.find<HomeController>().isLatestVersionAvailable.isTrue) ...[
                      IconButton(
                        onPressed: () async {
                          await showUpdateDialog(
                            isUpdateLoading: settingsController.isUpdateLoading,
                            downloadedProgress: settingsController.downloadedProgress,
                            onUpdate: () async {
                              await settingsController.downloadAndInstallService();
                            },
                          );
                        },
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          maximumSize: Size(6.w, 6.w),
                          minimumSize: Size(6.w, 6.w),
                        ),
                        icon: Icon(
                          Icons.arrow_circle_up_rounded,
                          color: AppColors.DARK_GREEN_COLOR,
                          size: 6.w,
                        ),
                      ),
                      SizedBox(width: 2.w),
                    ],
                    Obx(() {
                      return Text(
                        AppConstance.appVersion.replaceAll('1.0.0', settingsController.appVersion.value),
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR.withOpacity(0.55),
                          fontWeight: FontWeight.w700,
                          fontSize: context.isPortrait ? 16.sp : 12.sp,
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: 5.h),

          ///Change Language
          ExpansionTile(
            controller: settingsController.expansionTileController,
            title: Text(
              AppStrings.changeLanguage.tr,
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
            collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR,
            backgroundColor: AppColors.LIGHT_SECONDARY_COLOR,
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            childrenPadding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
            children: [
              Divider(
                color: AppColors.PRIMARY_COLOR,
                thickness: 1,
              ),
              SizedBox(height: 1.h),
              Obx(() {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50.w, minHeight: 0.w, maxWidth: 90.w, minWidth: 90.w),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 5.w,
                    childAspectRatio: 3,
                    children: [
                      ///Gujarati
                      InkWell(
                        onTap: () async {
                          await setData(AppConstance.languageCode, 'gu');
                          await setData(AppConstance.languageCountryCode, 'IN');
                          await Get.updateLocale(
                            Locale(getString(AppConstance.languageCode) ?? 'gu', getString(AppConstance.languageCountryCode) ?? 'IN'),
                          );
                          settingsController.isGujaratiLang(true);
                          settingsController.isHindiLang(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                opacity: settingsController.isGujaratiLang.isTrue ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.done_rounded,
                                  size: 6.w,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppStrings.gujarati.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///English
                      InkWell(
                        onTap: () async {
                          await setData(AppConstance.languageCode, 'en');
                          await setData(AppConstance.languageCountryCode, 'IN');
                          await Get.updateLocale(
                            Locale(getString(AppConstance.languageCode) ?? 'en', getString(AppConstance.languageCountryCode) ?? 'IN'),
                          );
                          settingsController.isGujaratiLang(false);
                          settingsController.isHindiLang(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                opacity: settingsController.isGujaratiLang.isFalse && settingsController.isHindiLang.isFalse ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.done_rounded,
                                  size: 6.w,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppStrings.english.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///Hindi
                      InkWell(
                        onTap: () async {
                          await setData(AppConstance.languageCode, 'hi');
                          await setData(AppConstance.languageCountryCode, 'IN');
                          await Get.updateLocale(
                            Locale(getString(AppConstance.languageCode) ?? 'hi', getString(AppConstance.languageCountryCode) ?? 'IN'),
                          );
                          settingsController.isGujaratiLang(false);
                          settingsController.isHindiLang(true);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                opacity: settingsController.isHindiLang.isTrue ? 1 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.done_rounded,
                                  size: 6.w,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppStrings.hindi.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
          const Spacer(),

          ///LogOut
          ButtonWidget(
            onPressed: () {
              clearData();
              Get.offAllNamed(Routes.signInScreen);
            },
            buttonTitle: AppStrings.logOut.tr,
            fixedSize: Size(double.maxFinite, 5.h),
          ),
          SizedBox(height: 2.h),

          Center(
            child: Text(
              AppStrings.copyrightContext.replaceAll('2024', DateTime.now().year.toString()),
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR.withOpacity(0.55),
                fontWeight: FontWeight.w700,
                fontSize: context.isPortrait ? 14.sp : 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
