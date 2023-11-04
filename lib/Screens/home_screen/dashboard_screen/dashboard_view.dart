import 'package:flutter/material.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
import 'package:ftc_stocks/Widgets/background_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      bgColorTop: AppColors.WHITE_COLOR,
      bgColorBottom: AppColors.WHITE_COLOR,
      child: Column(
        children: [
          Container(
            color: AppColors.SECONDARY_COLOR,
            alignment: Alignment.center,
            width: 100.w,
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Text(
              'FTC Stocks',
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
