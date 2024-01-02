import 'package:flutter/material.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Screens/home_screen/settings_screen/settings_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/settings_screen/settings_view.dart';
import 'package:get/get.dart';

class SettingsNavigator extends StatelessWidget {
  const SettingsNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Get.nestedKey(3),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          default:
            return GetPageRoute(
              routeName: Routes.settingsScreen,
              page: () => const SettingsView(),
              binding: SettingsBinding(),
              transition: Transition.rightToLeftWithFade,
              transitionDuration: transitionDuration,
            );
        }
      },
    );
  }
}
