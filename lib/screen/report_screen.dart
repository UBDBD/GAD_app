import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('리포트'),
      ),
      body: const Center(
        child: Text(
          '리포트 페이지입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}