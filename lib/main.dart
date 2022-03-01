import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

import 'screens/otp_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return MultiProvider(
            providers: [Provider<Auth>(create: (ctx) => Auth())],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                fontFamily: 'Roboto',
                primarySwatch: Colors.pink,
              ),
              home: AnimatedSplashScreen(
                duration: 10,
                splash: Image.asset(
                  'assets/images/Logo.png',
                  height: 200,
                  width: 300,
                ),
                nextScreen: const OnBoardingScreen(),
                animationDuration: const Duration(seconds: 5),
              ),
              routes: {
                AuthScreen.routeName: (ctx) => const AuthScreen(),
                HomePage.routeName: (ctx) => const HomePage(),
                OtpScreen.routeName: (ctx) => const OtpScreen(),
              },
            ),
          );
        });
  }
}
