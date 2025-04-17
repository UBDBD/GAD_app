import 'package:flutter/material.dart';

/// 교육 메인 페이지
class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            _buildImagePlaceholder(),
            const SizedBox(height: 24),
            _cardContainer(
              title: '목표',
              child: Column(
                children: [
                  _educationTile(context, '인지 행동 치료 알아보기', '/education1'),
                  _educationTile(context, '학습 주제2', '/'),
                  _educationTile(context, '학습 주제3', '/'),
                  _educationTile(context, '학습 주제4', '/'),
                  _educationTile(context, '학습 주제5', '/'),
                  _educationTile(context, '학습 주제6', '/'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 AppBar 구성
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
      title: const Text('교육', style: TextStyle(color: Colors.black)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            ),
          ),
        ),
      ],
    );
  }

  /// 이미지 또는 배너 영역
  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: const Center(
        child: Text('이미지 영역 (예: week1.png)', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  /// 학습 주제 카드 한 줄
  Widget _educationTile(BuildContext context, String title, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, color: Colors.indigo),
          Expanded(child: Text(title)),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacementNamed(context, route),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade100,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: const Size(0, 32),
            ),
            child: const Text(
              '이동하기',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  /// 카드형 컨테이너 (제목 + 콘텐츠)
  Widget _cardContainer({
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
          // 제목 + 우측 위젯 (옵션)
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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