import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_color.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Localization/localization.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      translations: Localization(),
      locale: const Locale('gu', 'IN'),
      fallbackLocale: const Locale('en', 'IN'),
      theme: ThemeData(
        primaryColor: AppColors.PRIMARY_COLOR,
        textTheme: GoogleFonts.nunitoSansTextTheme(),
        datePickerTheme: DatePickerThemeData(headerBackgroundColor: AppColors.SECONDARY_COLOR),
      ),
      initialRoute: Routes.splashScreen,
      defaultTransition: Transition.downToUp,
      getPages: AppPages.pages,
    );
  }
}
