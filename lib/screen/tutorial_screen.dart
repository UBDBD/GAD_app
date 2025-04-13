import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/user_database.dart'; // 설문 제출 여부 확인용

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> tutorialPages = [
    {
      'icon': Icons.today,
      'title': '하루의 시작을 함께',
      'description': '오늘의 할 일과 리포트를 한눈에 확인하세요.',
    },
    {
      'icon': Icons.edit_note,
      'title': '감정과 생각을 기록해요',
      'description': '감정일기, 명상, 노출치료 등 다양한 도구를 제공합니다.',
    },
    {
      'icon': Icons.bar_chart,
      'title': '나의 변화 추적',
      'description': '통계를 통해 마음의 흐름을 시각적으로 확인할 수 있어요.',
    },
  ];

  Future<void> _goNext() async {
    if (_currentIndex < tutorialPages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      final hasSurvey = await UserDatabase.hasCompletedSurvey();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, hasSurvey ? '/home' : '/pretest');
    }
  }

  Future<void> _skipTutorial() async {
    final hasSurvey = await UserDatabase.hasCompletedSurvey();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, hasSurvey ? '/home' : '/pretest');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skipTutorial,
                  child: const Text(
                    '건너뛰기',
                    style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: tutorialPages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final page = tutorialPages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(page['icon'], size: 120, color: Colors.indigo),
                        const SizedBox(height: 32),
                        Text(
                          page['title'],
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['description'],
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                tutorialPages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.indigo : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _goNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _currentIndex == tutorialPages.length - 1 ? '시작하기' : '다음',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}