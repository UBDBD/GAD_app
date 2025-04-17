import 'package:flutter/material.dart';

/// 심신 이완 안내 화면
class BreathingMeditationScreen extends StatelessWidget {
  const BreathingMeditationScreen({super.key});

  /// 명상 전체 설명 다이얼로그
  void showBreathingGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(18),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const Text('가이드',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Divider(),
              Expanded(
                child: ListView(
                  children: const [
                    Text(
                      '호흡 명상 안내',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('편안한 자세로 천천히 숨을 들이쉬고 내쉬며, 호흡의 리듬에 집중해봅니다.'),
                    SizedBox(height: 8),
                    Text('60초간 진행됩니다. \n5초간 들이쉬고, 5초간 내쉬는 호흡을 반복하며 마음을 차분하게 가라앉혀 보세요.\n'),
                    Text(
                      '점진적 근육 이완 안내',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('각 부위를 5초간 긴장 → 10초간 이완하세요.'),
                    SizedBox(height: 8),
                    Text('1. 팔꿈치 아래 \n주먹을 꼭 쥐고 몸 쪽으로 손목을 굽혀 팔꿈치 아랫부분을 긴장시키세요.'),
                    SizedBox(height: 4),
                    Text('2. 팔꿈치 윗부분 \n손끝을 어깨에 올려 이두 부위를 최대한 접어 긴장시키세요.'),
                    SizedBox(height: 4),
                    Text('3. 무릎 아래 \n다리를 들어 발끝을 몸 쪽으로 당겨 종아리를 긴장시키세요.'),
                    SizedBox(height: 4),
                    Text('4. 배 \n배를 안으로 강하게 조이며 긴장시켜 주세요.'),
                    SizedBox(height: 4),
                    Text('5. 가슴 \n깊게 숨을 들이쉬고 숨을 참아 가슴 근육을 당기세요.'),
                    SizedBox(height: 4),
                    Text('6. 어깨 \n어깨를 귀 쪽으로 올려 긴장시켜 주세요.'),
                    SizedBox(height: 4),
                    Text('7. 목 \n턱을 가슴 쪽으로 당겨 목 뒤를 당기세요.'),
                    SizedBox(height: 4),
                    Text('8. 얼굴 \n입술을 다물고 눈을 감은 채 얼굴 전체에 힘을 주세요.'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    fixedSize: const Size(140, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('닫기', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// AppBar 구성
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
      title: const Text('심신 이완', style: TextStyle(color: Colors.black)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, '/home', (_) => false),
          ),
        ),
      ],
    );
  }

  /// 안내 카드
  Widget _buildCardContainer({
    required BuildContext context,
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // 이미지 영역
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: const Center(
                child: Text('이미지 영역', style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 24),

            // 가이드 카드
            _buildCardContainer(
              context: context,
              title: '가이드',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      '호흡은 규칙적이고, 온몸은 이완되며 편안함을 느낍니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('호흡과 감각에 집중하세요.',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 6),
                  const Text('호흡이 안정되면, 몸의 각 부위를 차례로 긴장시켰다가 이완해봅니다.',
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => showBreathingGuideDialog(context),
                      child: const Text('자세히 보기'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/breathing_meditation');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        fixedSize: const Size(140, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('시작', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}