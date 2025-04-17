import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 로그인 화면: 이메일과 비밀번호로 인증
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 사용자 입력 필드 컨트롤러
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// 에러 메시지 표시용 SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// 로그인 처리 로직
  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 이메일 또는 비밀번호가 비어있을 경우
    if (email.isEmpty || password.isEmpty) {
      _showError('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    try {
      // Firebase 인증 시도
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) throw FirebaseAuthException(code: 'user-not-found');

      // Firestore에서 사용자 정보 가져오기
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // 로그인 상태 로컬 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('uid', user.uid);

      if (!mounted) return;

      // 튜토리얼 화면으로 이동 (로그인 완료)
      Navigator.pushReplacementNamed(
        context,
        '/tutorial',
        arguments: {
          'uid': user.uid,
          'email': user.email,
          'userData': userDoc.data(),
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      _handleLoginError(e.code, email, password);
    } catch (e) {
      _showError('알 수 없는 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  /// Firebase 인증 에러 처리
  void _handleLoginError(String code, String email, String password) {
    switch (code) {
      case 'user-not-found':
        // 가입된 사용자가 없을 경우 약관 화면으로 이동 (회원가입)
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
        _showError('로그인 시도가 너무 많습니다. 잠시 후 다시 시도해주세요.');
        break;
      case 'operation-not-allowed':
        _showError('이메일/비밀번호 로그인이 비활성화되어 있습니다.');
        break;
      default:
        _showError('로그인 실패: $code');
    }
  }

  /// 회원가입 화면으로 이동
  void _goToSignup() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    Navigator.pushNamed(context, '/terms', arguments: {
      'email': email,
      'password': password,
    });
  }

  /// 이메일 / 비밀번호 입력 텍스트필드
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  /// 로그인 버튼
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _login,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text('로그인'),
      ),
    );
  }

  /// 회원가입 버튼
  Widget _buildSignupButton() {
    return TextButton(
      onPressed: _goToSignup,
      child: const Text('회원가입'),
    );
  }

  /// 전체 로그인 화면 UI 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 로고 이미지 표시
              Center(
                child: Image.asset(
                  'assets/image/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              // 이메일 입력
              _buildTextField(
                controller: emailController,
                label: '이메일',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // 비밀번호 입력
              _buildTextField(
                controller: passwordController,
                label: '비밀번호',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 12),
              _buildSignupButton(),
            ],
          ),
        ),
      ),
    );
  }
}