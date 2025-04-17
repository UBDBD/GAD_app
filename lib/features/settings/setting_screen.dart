import 'package:flutter/material.dart';

/// 설정 화면
/// - 알림 토글 스위치
/// - 고객센터 문의 전송
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isTaskReminderOn = true;
  bool _isHomeworkReminderOn = true;
  bool _isReportReminderOn = true;

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  /// 고객센터 문의 전송
  void _sendInquiry() {
    final subject = _subjectController.text;
    final message = _messageController.text;
    if (subject.isNotEmpty && message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('문의가 접수되었습니다.')),
      );
      _subjectController.clear();
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목을 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        titleSpacing: 6,
        title: const Row(
          children: [
            Text('설정', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            // 알림 설정 영역
            _buildContainer(
              title: '알림 설정',
              child: Column(
                children: [
                  _buildSwitchTile('치료 일정 알림', _isTaskReminderOn, (value) {
                    setState(() => _isTaskReminderOn = value);
                  }),
                  _buildSwitchTile('숙제 제출 알림', _isHomeworkReminderOn, (value) {
                    setState(() => _isHomeworkReminderOn = value);
                  }),
                  _buildSwitchTile('리포트 생성 알림', _isReportReminderOn, (value) {
                    setState(() => _isReportReminderOn = value);
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 고객센터 문의 영역
            _buildContainer(
              title: '고객센터 문의',
              child: Column(
                children: [
                  _buildTextField('문의 제목', _subjectController),
                  _buildTextField('문의 내용', _messageController),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      fixedSize: const Size(140, 50),
                    ),
                    onPressed: _sendInquiry,
                    child: const Text('문의 전송', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 섹션 박스 컨테이너
  Widget _buildContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  /// 스위치 UI (알림용)
  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  /// 텍스트 입력 필드
  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: label == '문의 내용' ? 4 : 1,
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.indigo),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
