import 'package:ftc_stocks/Screens/home_screen/add_new_product_screen/add_new_product_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/dashboard_screen/dashboard_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/home_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/home_view.dart';
import 'package:ftc_stocks/Screens/home_screen/orders_history_screen/orders_history_binding.dart';
import 'package:ftc_stocks/Screens/home_screen/settings_screen/settings_binding.dart';
import 'package:ftc_stocks/Screens/password_screen/passoword_binding.dart';
import 'package:ftc_stocks/Screens/password_screen/password_view.dart';
import 'package:ftc_stocks/Screens/signin_screen/signin_binding.dart';
import 'package:ftc_stocks/Screens/signin_screen/signin_view.dart';
import 'package:ftc_stocks/Screens/splash_screen/splash_binding.dart';
import 'package:ftc_stocks/Screens/splash_screen/splash_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

Duration transitionDuration = const Duration(milliseconds: 400);

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splashScreen,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.signInScreen,
      page: () => const SignInView(),
      binding: SignInBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.passwordScreen,
      page: () => const PasswordView(),
      binding: PasswordBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.homeScreen,
      page: () => const HomeView(),
      bindings: [
        HomeBinding(),
        DashboardBinding(),
        AddNewProductBinding(),
        OrdersHistoryBinding(),
        SettingsBinding(),
      ],
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
  ];
}
