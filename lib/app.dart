import 'package:flutter/material.dart';

// Feature imports
import 'package:flutter_application_1/features/auth/login_screen.dart';
import 'package:flutter_application_1/features/auth/signup_screen.dart';
import 'package:flutter_application_1/features/auth/terms_screen.dart';
import 'package:flutter_application_1/features/other/splash_screen.dart';
import 'package:flutter_application_1/features/other/tutorial_screen.dart';
import 'package:flutter_application_1/features/other/pretest_screen.dart';
import 'package:flutter_application_1/features/settings/setting_screen.dart';

// Menu imports
import 'package:flutter_application_1/features/menu/contents_screen.dart';
import 'package:flutter_application_1/features/menu/education/education_screen.dart';
import 'package:flutter_application_1/features/menu/education/education1.dart';
import 'package:flutter_application_1/features/menu/relaxation/relaxation_screen.dart';
import 'package:flutter_application_1/features/menu/relaxation/breathing_meditation.dart';
import 'package:flutter_application_1/features/menu/relaxation/muscle_relaxation.dart';

// Navigation screen imports
import 'package:flutter_application_1/navigation/screen/home_screen.dart';
import 'package:flutter_application_1/navigation/screen/myinfo_screen.dart';

/// Mindrium 메인 앱 클래스
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
        // 인증 관련
        '/login': (context) => const LoginScreen(),
        '/terms': (context) => const TermsScreen(),
        '/signup': (context) => const SignupScreen(),

        // 네비게이션
        '/tutorial': (context) => const TutorialScreen(),
        '/pretest': (context) => const PreTestScreen(),
        '/home': (context) => const HomeScreen(),
        '/myinfo': (context) => const MyInfoScreen(),

        // 메뉴
        '/contents': (context) => const ContentScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/education': (context) => const EducationPage(),
        '/education1': (context) => const Education1Page(),
        '/breath_muscle_relaxation': (context) => const BreathingMeditationScreen(),
        '/breathing_meditation': (context) => const BreathingMeditationPage(), 
        '/muscle_relaxation': (context) => const MuscleRelaxationPage(),
      },
    );
  }
}