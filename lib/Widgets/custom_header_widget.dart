import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_assets.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String title;
  final String titleIcon;
  final double? titleIconSize;
  final void Function()? onBackPressed;

  const CustomHeaderWidget({
    super.key,
    required this.title,
    required this.titleIcon,
    this.onBackPressed,
    this.titleIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onBackPressed != null) ...[
          IconButton(
            onPressed: onBackPressed,
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
        ],
        Text(
          title,
          style: TextStyle(
            color: AppColors.PRIMARY_COLOR,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(width: 2.w),
        Image.asset(
          titleIcon,
          width: titleIconSize ?? 8.w,
        ),
      ],
    );
  }
}
