import 'package:flutter/material.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기록'),
      ),
      body: const Center(
        child: Text(
          '기록 페이지입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}