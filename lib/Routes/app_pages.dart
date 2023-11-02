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
  ];
}
