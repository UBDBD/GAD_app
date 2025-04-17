import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 실행 시 처음 보여지는 스플래시 화면
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  /// SharedPreferences에서 로그인 상태 확인
  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getBool('isLoggedIn');
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        // 데이터가 아직 로드되지 않았을 때: 스플래시 UI 보여주기
        if (!snapshot.hasData) {
          return _buildSplashUI();
        }

        // 데이터가 로드된 후: 로그인 여부에 따라 화면 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final isLoggedIn = snapshot.data ?? false;
          Navigator.pushReplacementNamed(
            context,
            isLoggedIn ? '/home' : '/login',
          );
        });

        return _buildSplashUI();
      },
    );
  }

  /// 스플래시 화면 UI
  Widget _buildSplashUI() {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/image/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Mindrium',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(
                  color: Colors.indigo,
                ),
              ],
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text(
              '걱정하지 마세요. 충분히 잘하고있어요.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}