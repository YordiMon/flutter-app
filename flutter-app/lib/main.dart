import 'package:flutter/material.dart';
import 'package:project/theme/dark_theme.dart';
import 'package:project/theme/light_theme.dart';
// ignore: unused_import
import 'package:project/onBoarding/onBoarding_view.dart';
// ignore: unused_import
import 'package:project/screens/genres/GenreList.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import
import 'LoginPage.dart';
// ignore: unused_import
import 'NavigationMenu.dart';
// ignore: unused_import
import 'HistoriesPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding")??false;

  runApp( MyApp(onboarding: onboarding));
}

class MyApp extends StatelessWidget {
  final bool onboarding;
  const MyApp({super.key, this.onboarding = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Branch',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: onboarding? const LoginPage() : const OnBoardingView(),
    );
  }
}