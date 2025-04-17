import 'package:flutter/material.dart';

/// 콘텐츠 메뉴 화면
class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            _buildContentButton(
              context,
              icon: Icons.local_library,
              label: '교육',
              route: '/education',
            ),
            const SizedBox(height: 16),
            _buildContentButton(
              context,
              icon: Icons.self_improvement,
              label: '심신 이완',
              route: '/breath_muscle_relaxation',
            ),
            const SizedBox(height: 16),
            _buildContentButton(
              context,
              icon: Icons.edit_note,
              label: '걱정 일기',
              route: '/journaling',
            ),
            const SizedBox(height: 16),
            _buildContentButton(
              context,
              icon: Icons.healing,
              label: '노출 치료',
              route: '/exposure',
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar
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
      title: const Text('메뉴', style: TextStyle(color: Colors.black)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
          ),
        ),
      ],
    );
  }

  /// 콘텐츠 버튼 생성 위젯
  Widget _buildContentButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.indigo),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}