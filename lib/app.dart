import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scorelivepro/views/splash_screen/splash_screen.dart';

class ScoreLivePro extends StatelessWidget {
  const ScoreLivePro({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // 1. Define the design size for screen adaptation
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,

      // 2. The builder returns the root widget (MaterialApp)
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Score Live Pro",
          theme: ThemeData(),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}
