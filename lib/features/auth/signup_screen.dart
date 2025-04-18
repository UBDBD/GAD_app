import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 회원가입 화면 - 이메일, 이름, 비밀번호, 마인드리움 코드로 회원가입
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 입력 필드 컨트롤러
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();

  // 비밀번호 보기 토글
  bool showPassword = false;
  bool showConfirmPassword = false;

  /// 에러 메시지를 스낵바로 출력
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 입력한 코드가 유효한지 Firestore에서 확인
  Future<bool> checkMindriumCode(String inputCode) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('codes').doc(inputCode).get();
      return doc.exists && (doc.data()?['valid'] == true);
    } catch (e) {
      debugPrint("코드 확인 중 오류 발생: $e");
      return false;
    }
  }

  /// 회원가입 처리 로직
  Future<void> _signup() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final code = codeController.text.trim();

    // 모든 필드 입력 확인
    if ([email, name, password, confirmPassword, code].any((e) => e.isEmpty)) {
      _showError('모든 필드를 입력해주세요.');
      return;
    }

    if (password.length < 6) {
      _showError('비밀번호는 6자리 이상이어야 합니다.');
      return;
    }

    if (password != confirmPassword) {
      _showError('비밀번호가 일치하지 않습니다.');
      return;
    }

    // 코드 유효성 확인
    final isValidCode = await checkMindriumCode(code);
    if (!isValidCode) {
      _showError('유효하지 않은 마인드리움 코드입니다.');
      return;
    }

    try {
      // Firebase Auth를 이용한 사용자 생성
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore에 사용자 정보 저장
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'code': code,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다.')),
      );

      // 로그인 화면으로 이동
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      // 이메일 중복 시 → 로그인 화면으로 안내
      if (e.code == 'email-already-in-use') {
        _showError('이미 등록된 이메일입니다. 로그인 화면으로 이동합니다.');
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login', arguments: {
          'email': email,
          'password': password,
        });
      } else if (e.code == 'network-request-failed') {
        _showError('네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.');
      } else {
        _showError('회원가입 실패: ${e.message}');
        debugPrint("FirebaseAuthException: ${e.code} / ${e.message}");
      }
    } catch (e, stack) {
      _showError('알 수 없는 오류 발생: $e');
      debugPrint("Exception: $e");
      debugPrint("Stack trace: $stack");
    }
  }

  /// 로그인 화면에서 넘어온 이메일/비밀번호 초기값 처리
  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      emailController.text = args['email'] ?? '';
      passwordController.text = args['password'] ?? '';
    }
    super.didChangeDependencies();
  }

  /// 전체 UI 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(emailController, '이메일', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(nameController, '이름'),
            const SizedBox(height: 16),
            _buildPasswordField(
              passwordController,
              '비밀번호',
              showPassword,
              () => setState(() => showPassword = !showPassword),
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              confirmPasswordController,
              '비밀번호 확인',
              showConfirmPassword,
              () => setState(() => showConfirmPassword = !showConfirmPassword),
            ),
            const SizedBox(height: 16),
            _buildTextField(codeController, '마인드리움 코드'),
            const SizedBox(height: 24),
            _buildSignupButton(),
          ],
        ),
      ),
    );
  }

  /// 일반 텍스트 필드
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  /// 비밀번호 필드 (보기 토글 포함)
  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  /// 회원가입 버튼 위젯
  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _signup,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text('회원가입', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}