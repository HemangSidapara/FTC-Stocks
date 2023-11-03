import 'package:ftc_stocks/Screens/dashboard_screen/dashboard_binding.dart';
import 'package:ftc_stocks/Screens/dashboard_screen/dashboard_view.dart';
import 'package:ftc_stocks/Screens/otp_screen/passoword_binding.dart';
import 'package:ftc_stocks/Screens/otp_screen/password_view.dart';
import 'package:ftc_stocks/Screens/signin_screen/signin_view.dart';
import 'package:ftc_stocks/Screens/signin_screen/singin_binding.dart';
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
      name: Routes.dashboardScreen,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
  ];
}
