import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool agreedTerms = false;
  bool agreedPrivacy = false;

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final email = args['email']!;
    final password = args['password']!;
    final allChecked = agreedTerms && agreedPrivacy;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('약관 동의'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.verified_user, size: 72, color: Colors.indigo),
            const SizedBox(height: 24),
            _buildCheckTile(
              title: '이용약관 동의',
              value: agreedTerms,
              onChanged: (v) => setState(() => agreedTerms = v ?? false),
              onViewPressed: () {
                _showDialog('이용약관', '여기에 이용약관의 자세한 내용을 입력하세요.');
              },
            ),
            const SizedBox(height: 12),
            _buildCheckTile(
              title: '개인정보 수집 및 이용 동의',
              value: agreedPrivacy,
              onChanged: (v) => setState(() => agreedPrivacy = v ?? false),
              onViewPressed: () {
                _showDialog('개인정보 수집 및 이용 동의', '여기에 개인정보 처리방침 내용을 입력하세요.');
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: allChecked
                    ? () {
                        Navigator.pushNamed(context, '/signup', arguments: {
                          'email': email,
                          'password': password,
                        });
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('다음으로',
                  style: TextStyle(fontSize: 16)
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onViewPressed,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.indigo,
          ),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          TextButton(
            onPressed: onViewPressed,
            child: const Text('더보기', style: TextStyle(color: Colors.indigo)),
          ),
        ],
      ),
    );
  }
}