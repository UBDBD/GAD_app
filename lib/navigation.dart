import 'package:flutter/material.dart';
import 'screen/home_screen.dart';  
import 'screen/treatment_screen.dart';
import 'screen/record_screen.dart';
import 'screen/report_screen.dart';
import 'screen/myinfo_screen.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: Colors.grey.shade100,
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.local_hospital_outlined), label: '치료'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: '기록'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: '리포트'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '내 정보'),
        ],
      ),
    );
  }

  static List<Widget> getPages() {
    return [
      const HomeScreen(),
      const TreatmentScreen(),
      const RecordsScreen(),
      const ReportScreen(),
      const MyInfoScreen(),
    ];
  }
}

