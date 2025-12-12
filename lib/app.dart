import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/views/splash_screen/splash_screen.dart';

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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Score Live Pro",
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
