import 'package:flutter/material.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/add_new_product_screen/add_new_product_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/add_new_product_screen/add_new_product_view.dart';
import 'package:get/get.dart';

class AddNewProductNavigator extends StatelessWidget {
  const AddNewProductNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(1),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          default:
            return GetPageRoute(
              routeName: Routes.addNewProductScreen,
              page: () => const AddNewProductView(),
              binding: AddNewProductBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
            );
        }
      },
    );
  }
}
