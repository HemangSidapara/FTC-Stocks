import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DropDownWidget extends StatelessWidget {
  final String? title;
  final String? hintText;
  final List<DropdownMenuItem<int>>? items;
  final List<Widget> Function(BuildContext context)? selectedItemBuilder;
  final String? Function(int? value)? validator;
  final void Function(int? value)? onChanged;
  final void Function(int?)? onSaved;
  final int? value;
  final List<Widget>? titleChildren;

  const DropDownWidget({
    super.key,
    this.title,
    this.hintText,
    required this.items,
    this.selectedItemBuilder,
    this.validator,
    required this.onChanged,
    this.onSaved,
    this.value,
    this.titleChildren,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  title!,
                  style: TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: titleChildren ?? [],
              ),
            ],
          ),
        ],
        SizedBox(height: 1.h),
        DropdownButtonFormField(
          style: TextStyle(
            color: AppColors.PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
          alignment: Alignment.topLeft,
          decoration: InputDecoration(
            filled: true,
            enabled: true,
            fillColor: AppColors.WHITE_COLOR,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
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
            errorMaxLines: 2,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h).copyWith(right: 1.5.w),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.SECONDARY_COLOR,
            size: 5.w,
          ),
          dropdownColor: AppColors.WHITE_COLOR,
          items: items,
          disabledHint: Text(
            AppStrings.noDataFound.tr,
            style: TextStyle(
              color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          selectedItemBuilder: selectedItemBuilder,
          validator: validator,
          onChanged: onChanged,
          onSaved: onSaved,
          value: value,
        ),
      ],
    );
  }
}
