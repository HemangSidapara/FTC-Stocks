import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';

class TextFieldWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final int? maxLength;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;

  const TextFieldWidget({
    super.key,
    required this.title,
    this.controller,
    this.validator,
    required this.hintText,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.WHITE_COLOR,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          validator: validator,
          style: TextStyle(
            color: AppColors.WHITE_COLOR,
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
          ),
          obscureText: obscureText ?? false,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          maxLength: maxLength,
          cursorColor: AppColors.WHITE_COLOR,
          decoration: InputDecoration(
            counterStyle: TextStyle(color: AppColors.WHITE_COLOR),
            filled: true,
            enabled: true,
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: TextStyle(
              color: AppColors.WHITE_COLOR.withOpacity(0.5),
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
            errorStyle: TextStyle(
              color: AppColors.PRIMARY_COLOR,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.PRIMARY_COLOR,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.PRIMARY_COLOR,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.WHITE_COLOR,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: AppColors.WHITE_COLOR,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
