import 'package:flutter/material.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';

class CustomScaffoldWidget extends StatelessWidget {
  final Widget child;
  final bool isPadded;
  final EdgeInsetsGeometry? scaffoldPadding;

  const CustomScaffoldWidget({
    super.key,
    required this.child,
    this.isPadded = false,
    this.scaffoldPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: isPadded
            ? Padding(
                padding: scaffoldPadding ?? EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                child: child,
              )
            : child,
      ),
    );
  }
}
