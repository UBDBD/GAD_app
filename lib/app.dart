import 'package:flutter/material.dart';
import 'screen/splash_screen.dart'; 
import 'screen/login_screen.dart';
import 'screen/terms_screen.dart';
import 'screen/signup_screen.dart';
import 'screen/tutorial_screen.dart';
import 'screen/pretest_screen.dart';

import 'screen/home_screen.dart';
import 'reference/education/education_screen.dart';
import 'reference/breathing_meditaion/breathing_meditation_screen.dart';

import 'screen/myinfo_screen.dart';
import 'reference/setting_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mindrium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/terms': (context) => const TermsScreen(),
        '/signup': (context) => const SignupScreen(),
        '/tutorial': (context) => const TutorialScreen(),
        '/pretest': (context) => const PreTestScreen(),
        '/home': (context) => const HomeScreen(),
        '/myinfo': (context) => const MyInfoScreen(),

        '/settings': (context) => const SettingsScreen(),
        '/education': (context) => const EducationPage(),
        '/breathing_meditation': (context) => const BreathingMeditationScreen(),

      },
    );
  }
}