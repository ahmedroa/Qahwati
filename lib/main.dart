import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qahwati/core/colors.dart';
import 'package:qahwati/firebase_options.dart';
import 'package:qahwati/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'قهوتي',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorsManager.coffeeButton,
          ),
          scaffoldBackgroundColor: ColorsManager.screenBackground,
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorsManager.screenBackground,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          fontFamily: 'Tajawal',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
