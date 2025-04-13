import 'package:flutter/material.dart';
import 'breathing_meditation.dart';

class BreathingMeditationScreen extends StatelessWidget {
  const BreathingMeditationScreen({super.key});

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
            onPressed: () =>
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
          ),
        ),
        titleSpacing: 6,
        title: const Row(
          children: [
            Text('호흡 명상', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () =>
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 60),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.indigo.shade100,
                      Colors.indigo,
                      Colors.indigo,
                    ],
                    center: Alignment.center,
                    radius: 0.85,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.self_improvement, size: 100, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 36),
            _cardContainer(
              context: context,
              title: '호흡 명상 가이드',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '움직임을 멈추고 \n호흡에 집중하십시오.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '눈을 감고 깊게 들이쉬고 내쉬는 데 집중해 보세요.\n긴장을 푸는 데 도움이 됩니다.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BreathingMeditationPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade100,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    label: const Text('시작하기')
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardContainer({
    required BuildContext context,
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}