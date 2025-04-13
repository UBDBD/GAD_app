import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
        if (!snapshot.hasData) {
          return _buildSplashUI();
        }

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
                  'assets/logo.png',
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
            padding: EdgeInsets.only(bottom: 32.0),
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