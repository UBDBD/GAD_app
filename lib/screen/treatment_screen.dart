import 'package:flutter/material.dart';

class TreatmentScreen extends StatelessWidget {
  const TreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('치료'),
      ),
      body: const Center(
        child: Text(
          '치료 페이지입니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}