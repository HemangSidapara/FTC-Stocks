import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final String buttonTitle;

  const ButtonWidget({
    super.key,
    this.onPressed,
    this.child,
    this.buttonTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.PRIMARY_COLOR,
        elevation: 4,
        shadowColor: AppColors.WHITE_COLOR.withOpacity(0.7),
        fixedSize: Size(84.w, 5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: child ??
          Text(
            buttonTitle,
            style: TextStyle(
              color: AppColors.SECONDARY_COLOR,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
    );
  }
}
