import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/signin_screen/signin_controller.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/custom_scaffold_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  SignInController controller = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h).copyWith(bottom: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Heading
            Text(
              AppStrings.login.tr,
              style: TextStyle(
                color: AppColors.SECONDARY_COLOR,
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),

            ///Login Image
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.loginImage,
                      height: 35.h,
                    ),
                    SizedBox(height: 2.h),

                    ///Phone Field
                    Form(
                      key: controller.signInFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom != 0 ? 2.h : 0),
                        child: TextFieldWidget(
                          controller: controller.phoneNumberController,
                          title: AppStrings.phoneNumber.tr,
                          hintText: AppStrings.enterPhoneNumber.tr,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          maxLength: 10,
                          validator: (value) {
                            return controller.validatePhoneNumber(value!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///Submit
            ButtonWidget(
              onPressed: () async {
                await controller.checkLogin();
              },
              buttonTitle: AppStrings.next.tr,
            ),
          ],
        ),
      ),
    );
  }
}
