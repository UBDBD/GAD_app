import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/navigation/navigation.dart';
import 'package:flutter_application_1/data/providers/user_daycounter.dart';
import 'package:flutter_application_1/data/providers/user_provider.dart';

import 'treatment_screen.dart';
import 'record_screen.dart';
import 'report_screen.dart';
import 'myinfo_screen.dart';

/// 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  int daysSinceJoin = 0;
  final String date = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // 사용자 정보 초기화
    Future.microtask(() {
      if (!mounted) return;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final dayCounter = Provider.of<UserDayCounter>(context, listen: false);
      userProvider.loadUserData(dayCounter: dayCounter);
    });
  }

  /// 하단 네비게이션 탭 전환 핸들러
  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _buildBody(),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }

  /// 선택된 탭에 따라 각 화면 반환
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _homePage();
      case 1:
        return const TreatmentScreen();
      case 2:
        return const RecordsScreen();
      case 3:
        return const ReportScreen();
      case 4:
        return const MyInfoScreen();
      default:
        return _homePage();
    }
  }

  /// 홈 페이지 구성
  Widget _homePage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildReportSummary(),
          const SizedBox(height: 16),
          _buildTodayTasks(),
        ],
      ),
    );
  }

  /// 상단 인사 및 날짜 표시
  Widget _buildHeader() {
    final userService = context.watch<UserProvider>();
    final dayCounter = context.watch<UserDayCounter>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${userService.userName}님,\n좋은 하루 되세요!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '${dayCounter.daysSinceJoin}일째 되는 날',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.pushNamed(context, '/contents');
          },
        ),
      ],
    );
  }

  /// 오늘의 할일 목록
  Widget _buildTodayTasks() {
    final tasks = ['일일 과제1', '일일 과제2', '일일 과제3', '일일 과제4', '일일 과제5'];

    return _cardContainer(
      title: '오늘의 할일',
      child: Column(
        children: List.generate(tasks.length, (index) => _taskTile(tasks[index])),
      ),
    );
  }

  /// 할일 항목
  Widget _taskTile(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_outlined, color: Colors.indigo),
          Expanded(child: Text(title)),
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/pretest'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(0, 32),
              ),
              child: const Text('수행하기', style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  /// 주간 불안 점수 요약 차트
  Widget _buildReportSummary() {
    final anxietyScores = [5.0, 3.0, 4.0, 2.0, 1.0, 3.0, 5.0];

    return _cardContainer(
      title: '주간 불안감 변화',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 5,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      anxietyScores.length,
                      (index) => FlSpot(index.toDouble(), anxietyScores[index]),
                    ),
                    isCurved: true,
                    color: Colors.indigo,
                    barWidth: 2,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                        radius: 3,
                        color: Colors.indigo,
                        strokeColor: Colors.white,
                        strokeWidth: 1.5,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.withAlpha((255 * 0.2).toInt()),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '이번 주 평균 불안감: 5.1점',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// 공통 카드 스타일 컨테이너
  Widget _cardContainer({required String title, Widget? trailing, required Widget child}) {
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