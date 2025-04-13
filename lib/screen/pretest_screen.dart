import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/user_database.dart';

class PreTestScreen extends StatefulWidget {
  const PreTestScreen({super.key});

  @override
  State<PreTestScreen> createState() => _PreTestScreenState();
}

class _PreTestScreenState extends State<PreTestScreen> {
  int step = 0;

  final TextEditingController otherController = TextEditingController();

  final List<String> worries = [
    '건강 (자신과 타인의)',
    '재정 문제',
    '노화 관련 문제',
    '가족/친구 관계',
    '일상적 사건들',
    '일/봉사활동',
  ];
  List<String> selectedWorries = [];
  bool otherSelected = false;

  String? selectedSleepHours;
  String? selectedSleepQuality;

  void toggleWorryOption(String option) {
    setState(() {
      if (selectedWorries.contains(option)) {
        selectedWorries.remove(option);
      } else {
        selectedWorries.add(option);
      }
    });
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
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget buildIntroPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.description_outlined, size: 100, color: Colors.indigo),
        const SizedBox(height: 24),
        const Text('수면 건강 상태 조사',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Text(
          '수면과 건강 상태를 점검하기 위한 정기적인 설문을 시작할게요.\n'
          '설문과 수면 기록을 함께 분석해서 수면 문제를 올바르게 이해하고\n'
          '맞춤 프로그램을 구성해드립니다.\n\n'
          '소요 시간: 약 10분',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: () => setState(() => step = 1),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.indigo,
            minimumSize: const Size(140, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('시작하기', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget buildSurveyPage1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('생각', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('당신의 마음 속에 어떤 걱정이 있나요?', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        ...worries.map((option) => CheckboxListTile(
              value: selectedWorries.contains(option),
              onChanged: (_) => toggleWorryOption(option),
              title: Text(option, style: const TextStyle(fontSize: 16)),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              visualDensity: const VisualDensity(vertical: -2),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            )),
        CheckboxListTile(
          value: otherSelected,
          onChanged: (v) => setState(() => otherSelected = v ?? false),
          title: const Text('기타', style: TextStyle(fontSize: 16)),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        if (otherSelected)
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
            child: _buildTextField(
              controller: otherController,
              label: '기타 사항',
            ),
          ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = 0),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                backgroundColor: Colors.white,
                minimumSize: const Size(100, 50),
              ),
              child: const Text('이전', style: TextStyle(color: Colors.indigo)),
            ),
            FilledButton(
              onPressed: () => setState(() => step = 2),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(100, 50),
              ),
              child: const Text('다음'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSurveyPage2() {
    final sleepOptions = ['4시간 이하', '5~6시간', '7~8시간', '9시간 이상'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('수면 시간', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('하루 평균 수면 시간은 얼마나 되나요?', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        ...sleepOptions.map((option) => CheckboxListTile(
              value: selectedSleepHours == option,
              onChanged: (_) {
                setState(() {
                  selectedSleepHours = option;
                });
              },
              title: Text(option, style: const TextStyle(fontSize: 16)),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              visualDensity: const VisualDensity(vertical: -2),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            )),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = 1),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                backgroundColor: Colors.white,
                minimumSize: const Size(100, 50),
              ),
              child: const Text('이전', style: TextStyle(color: Colors.indigo)),
            ),
            FilledButton(
              onPressed: () => setState(() => step = 3),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(100, 50),
              ),
              child: const Text('다음'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSurveyPage3() {
    final qualityOptions = ['매우 나쁨', '나쁨', '보통', '좋음', '매우 좋음'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('수면의 질', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('최근 일주일 간 수면의 질은 어떤가요?', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        ...qualityOptions.map((option) => CheckboxListTile(
              value: selectedSleepQuality == option,
              onChanged: (_) {
                setState(() {
                  selectedSleepQuality = option;
                });
              },
              title: Text(option, style: const TextStyle(fontSize: 16)),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              visualDensity: const VisualDensity(vertical: -2),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            )),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () => setState(() => step = 2),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                backgroundColor: Colors.white,
                minimumSize: const Size(100, 50),
              ),
              child: const Text('이전', style: TextStyle(color: Colors.indigo)),
            ),
            FilledButton(
              onPressed: () => setState(() => step = 4),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(100, 50),
              ),
              child: const Text('완료'),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildResultPage() {
    Future.microtask(() {
      UserDatabase.saveSurveyResult(
        worries: selectedWorries,otherWorry: otherSelected ? otherController.text.trim() : null,
        sleepHours: selectedSleepHours,
        sleepQuality: selectedSleepQuality
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('불안증상 검사결과', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo, width: 2),
          ),
          child: const Text(
            '중간수준 (점수 10~14점)\n\n'
            '불안이 일상과 수면에 영향을 줄 가능성을 보고하셨습니다.\n'
            '추가적인 평가가 필요하며 전문가의 도움을 받아보시길 권해 드립니다.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.indigo,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('홈으로 돌아가기'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (step) {
      case 0:
        page = buildIntroPage();
        break;
      case 1:
        page = buildSurveyPage1();
        break;
      case 2:
        page = buildSurveyPage2();
        break;
      case 3:
        page = buildSurveyPage3();
        break;
      default:
        page = buildResultPage();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: page,
        ),
      ),
    );
  }
}
