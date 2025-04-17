import 'package:flutter/material.dart';

/// 교육 상세 페이지 - 주제 1
class Education1Page extends StatelessWidget {
  const Education1Page({super.key});

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
            _buildCardContainer(
              title: '교육 제목',
              child: const Text(
                '이곳에 교육 내용이 들어갑니다.\n'
                '내용이 길어질 경우 스크롤이 자동으로 가능합니다.\n'
                '예: 인지 행동 치료의 정의, 목적, 효과 등 설명.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 상단 AppBar (뒤로가기 + 홈 이동)
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
      title: const Text('1', style: TextStyle(color: Colors.black)),
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

  /// 상단 이미지/배너 영역
  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: const Center(
        child: Text(
          '이미지 영역 (예: week1.png)',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  /// 카드 형태 컨테이너 (제목 + 내용)
  Widget _buildCardContainer({
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
          // 제목 영역
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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