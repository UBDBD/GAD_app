import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase 설정 및 사용자 프로바이더
import 'package:flutter_application_1/data/firebase/firebase_options.dart';
import 'package:flutter_application_1/data/providers/user_provider.dart';
import 'package:flutter_application_1/data/providers/user_daycounter.dart';

import 'app.dart';

/// 앱 시작점 (entry point)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 (환경별 설정 적용)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 전역 상태 관리를 위한 MultiProvider 설정
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserDayCounter()),
      ],
      child: const MyApp(),
    ),
  );
}