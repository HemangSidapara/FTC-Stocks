import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget? child;
  final Color? bgColorTop;
  final Color? bgColorBottom;

  const BackgroundWidget({
    super.key,
    this.child,
    this.bgColorTop,
    this.bgColorBottom,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(),
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 40.h,
                      width: 100.w,
                      color: bgColorTop ?? AppColors.PRIMARY_COLOR,
                    ),
                    Container(
                      height: 60.h,
                      width: 100.w,
                      color: bgColorBottom ?? AppColors.SECONDARY_COLOR,
                    ),
                  ],
                ),
              ),
              child ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
