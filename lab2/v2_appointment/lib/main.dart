import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:v2_appointment/screens/home_screen.dart';
import 'package:v2_appointment/theme/app_colors.dart';
import 'package:v2_appointment/theme/app_text.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Bara de status transparentă cu iconițe închise, ca în design.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.white,
        fontFamily: AppText.openSansFamily,
      ),
      home: const HomeScreen(),
    );
  }
}
