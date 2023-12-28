import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final String buttonTitle;
  final Size? fixedSize;
  final OutlinedBorder? shape;
  final bool isLoading;

  const ButtonWidget({
    super.key,
    this.onPressed,
    this.child,
    this.buttonTitle = '',
    this.fixedSize,
    this.shape,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.PRIMARY_COLOR,
        surfaceTintColor: isLoading ? AppColors.PRIMARY_COLOR : null,
        elevation: 4,
        shadowColor: AppColors.WHITE_COLOR.withOpacity(0.7),
        fixedSize: fixedSize ?? Size(84.w, 5.h),
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
      ),
      child: isLoading
          ? SizedBox(
              height: 5.w,
              width: 5.w,
              child: CircularProgressIndicator(
                color: AppColors.WHITE_COLOR,
                strokeWidth: 1.6,
              ),
            )
          : child ??
              Text(
                buttonTitle,
                style: TextStyle(
                  color: AppColors.WHITE_COLOR,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
    );
  }
}
