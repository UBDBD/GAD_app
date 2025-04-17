import 'package:flutter/material.dart';
import 'screen/home_screen.dart';  
import 'screen/treatment_screen.dart';
import 'screen/record_screen.dart';
import 'screen/report_screen.dart';
import 'screen/myinfo_screen.dart';

/// 하단 네비게이션 바 커스텀 위젯
/// - 5개의 주요 탭(홈, 치료, 기록, 리포트, 내 정보) 제공
/// - 선택된 인덱스를 상태로 반영하고 콜백 전달
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

  /// 각 네비게이션 항목에 해당하는 페이지 반환 (선택된 인덱스 기반으로 활용 가능)
  static List<Widget> getPages() {
    return const [
      HomeScreen(),
      TreatmentScreen(),
      RecordsScreen(),
      ReportScreen(),
      MyInfoScreen(),
    ];
  }
}