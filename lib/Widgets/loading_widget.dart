import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 8.w,
          width: 8.w,
          child: CircularProgressIndicator(
            color: AppColors.PRIMARY_COLOR,
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }
}
