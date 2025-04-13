import 'package:flutter/material.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

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
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
          ),
        ),
        titleSpacing: 6,
        title: Row(
          children: const [
            Text('교육', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: const Center(child: Text('이미지 영역 (예: week1.png)', style: TextStyle(color: Colors.grey))),
            ),
            const SizedBox(height: 24),
            _cardContainer(
              title: '목표',
              child: Column(
                children: [
                  _educationTile(context, '인지 행동 치료 알아보기', '/education1_detail1'),
                  _educationTile(context, '...', '/education1_detail2'),
                  _educationTile(context, '학습 주제3', '/education1_detail3'),
                  _educationTile(context, '학습 주제4', '/education1_detail3'),
                  _educationTile(context, '학습 주제5', '/education1_detail3'),
                  _educationTile(context, '학습 주제6', '/education1_detail3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _educationTile(BuildContext context, String title, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, color: Colors.indigo),
          Expanded(child: Text(title)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade100,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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

  Widget _cardContainer({required String title, Widget? trailing, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
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