import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Constants/app_images.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Screens/signin_screen/signin_controller.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/background_widget.dart';
import 'package:ftc_stocks/Widgets/button_widget.dart';
import 'package:ftc_stocks/Widgets/textfield_widget.dart';
import 'package:get/get.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  SignInController controller = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
            SizedBox(height: 2.h),

            ///Login Image
            Image.asset(
              Images.loginImage,
              height: 35.h,
            ),
            SizedBox(height: 2.h),

            ///Phone Field
            Form(
              key: controller.signInFormKey,
              autovalidateMode: AutovalidateMode.always,
              child: TextFieldWidget(
                controller: controller.phoneNumberController,
                title: AppStrings.phoneNumber.tr,
                hintText: AppStrings.enterPhoneNumber.tr,
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  return controller.validatePhoneNumber(value!);
                },
              ),
            ),
            const Spacer(),

            ///Submit
            ButtonWidget(
              onPressed: () async {
                await controller.checkLogin();
              },
              buttonTitle: AppStrings.next.tr,
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}
