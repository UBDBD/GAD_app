import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../reference/setting_screen.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final userService = Provider.of<UserProvider>(context, listen: false);
      userService.fetchUserName().then((_) {
        _nameController.text = userService.userName;
        _emailController.text = userService.userEmail;
      });
    });
  }

  Future<void> _updateUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final newName = _nameController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기존 비밀번호를 입력해야 수정할 수 있습니다.')),
      );
      return;
    }

    if (newPassword.isNotEmpty && newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새 비밀번호가 일치하지 않습니다.')),
      );
      return;
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);

      await user.updateDisplayName(newName);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': newName,
      });

      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).updateUserName(newName);

      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호가 변경되었습니다. 다시 로그인해주세요.')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('계정 정보가 성공적으로 수정되었습니다.')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('수정 실패: ${e.message}')),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        toolbarHeight: 30,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildInfoCard(),
            const SizedBox(height: 30),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final userService = context.read<UserProvider>();
    final createdAt = userService.createdAt;
    final formattedDate = createdAt != null
        ? DateFormat('yyyy년 MM월 dd일').format(createdAt)
        : '가입일 정보 없음';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '계정 정보',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '가입일: $formattedDate',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoField('이름', _nameController),
          _buildInfoField('이메일', _emailController, enabled: false),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          _buildInfoField('기존 비밀번호', _currentPasswordController, obscureText: true),
          _buildInfoField('새 비밀번호', _newPasswordController, obscureText: true),
          _buildInfoField('새 비밀번호 확인', _confirmPasswordController, obscureText: true),
          const SizedBox(height: 16),
          Center(
            child: FilledButton(
              onPressed: _updateUserInfo,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.indigo.shade100,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                fixedSize: const Size(140, 50),
              ),
              child: const Text('계정 정보 수정', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return FilledButton(
      onPressed: _logout,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text('로그아웃',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16
        )
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller,
      {bool enabled = true, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}