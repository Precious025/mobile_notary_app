import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:uber_lyft/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: AnimatedSplashScreen(
        duration: 20,
        splash: Image.asset(
          'assets/images/Logo.png',
          height: 200,
          width: 300,
        ),
        nextScreen: const OnBoardingScreen(),
        animationDuration: const Duration(seconds: 10),
      ),
    );
  }
}
