import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('uid', credential.user!.uid);

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/tutorial',
        arguments: {
          'uid': credential.user!.uid,
          'email': credential.user!.email,
          'userData': userDoc.data(),
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      switch (e.code) {
        case 'user-not-found':
          Navigator.pushNamed(context, '/terms', arguments: {
            'email': email,
            'password': password,
          });
          break;
        case 'wrong-password':
          _showError('비밀번호가 잘못되었습니다.');
          break;
        case 'invalid-email':
          _showError('유효하지 않은 이메일 형식입니다.');
          break;
        case 'user-disabled':
          _showError('해당 계정은 비활성화되었습니다.');
          break;
        case 'too-many-requests':
          _showError('로그인 시도가 너무 많습니다. 나중에 다시 시도해주세요.');
          break;
        case 'operation-not-allowed':
          _showError('이메일/비밀번호 로그인이 활성화되어 있지 않습니다.');
          break;
        default:
          _showError('로그인 실패: ${e.message}');
      }
    } catch (e) {
      _showError('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  void _goToSignup() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    Navigator.pushNamed(context, '/terms', arguments: {
      'email': email,
      'password': password,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              _buildTextField(
                controller: emailController,
                label: '이메일',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: passwordController,
                label: '비밀번호',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _goToSignup,
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontSize: 16
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}