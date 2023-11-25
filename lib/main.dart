import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftc_stocks/Constants/app_colors.dart';
import 'package:ftc_stocks/Constants/app_constance.dart';
import 'package:ftc_stocks/Constants/app_strings.dart';
import 'package:ftc_stocks/Constants/get_storage.dart';
import 'package:ftc_stocks/Localization/localization.dart';
import 'package:ftc_stocks/Routes/app_pages.dart';
import 'package:ftc_stocks/Utils/app_sizer.dart';
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
    setSize(MediaQuery.sizeOf(context));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      translations: Localization(),
      locale: Locale(getString(AppConstance.languageCode) ?? 'gu', getString(AppConstance.languageCountryCode) ?? 'IN'),
      fallbackLocale: const Locale('en', 'IN'),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.WHITE_COLOR,
        primaryColor: AppColors.PRIMARY_COLOR,
        textTheme: GoogleFonts.interTextTheme(),
        datePickerTheme: DatePickerThemeData(headerBackgroundColor: AppColors.SECONDARY_COLOR),
      ),
      initialRoute: Routes.splashScreen,
      defaultTransition: Transition.downToUp,
      getPages: AppPages.pages,
    );
  }
}
