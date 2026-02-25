import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/core/app_colors.dart';
import 'package:scorelivepro/core/app_padding.dart';
import 'package:scorelivepro/views/splash_screen/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scorelivepro/l10n/app_localizations.dart';
import 'package:scorelivepro/provider/language_provider.dart';

class ScoreLivePro extends StatelessWidget {
  const ScoreLivePro({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // 1. Define the design size for screen adaptation
      designSize: const Size(390, 851),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (context, child) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Score Live Pro",
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: languageProvider.currentLocale,
              theme: ThemeData(
                scaffoldBackgroundColor: AppColors.white,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primaryColor,
                  fixedSize: Size.fromHeight(52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppPadding.c12,
                  ),
                  elevation: 0,
                )),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  fixedSize: Size.fromHeight(52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppPadding.c12,
                  ),
                  elevation: 0,
                )),
              ),
              home: child,
            );
          },
        );
      },
      child: const SplashScreen(),
    );
  }
}
