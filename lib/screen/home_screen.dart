import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/provider/user_daycounter.dart';

import 'treatment_screen.dart';
import 'record_screen.dart';
import 'report_screen.dart';
import 'myinfo_screen.dart';

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
    Future.microtask(() {
      if (!mounted) return;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final dayCounter = Provider.of<UserDayCounter>(context, listen: false);
      userProvider.fetchUserName(dayCounter: dayCounter);
    });
  }

  Future<void> fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      final uid = refreshedUser?.uid;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      setState(() {
        userName = doc.data()?['name'] ?? refreshedUser?.displayName ?? '사용자';
        
      });
    }
  }

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

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _homePage();  // 홈 페이지 내용
      case 1:
        return const TreatmentScreen();  // 치료 페이지
      case 2:
        return const RecordsScreen();  // 기록 페이지
      case 3:
        return const ReportScreen();  // 리포트 페이지
      case 4:
        return const MyInfoScreen(); 
      default:
        return _homePage();  // 기본은 홈 페이지
    }
  }

  Widget _homePage() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildReportSummary(),
          const SizedBox(height: 16),
          _buildTodayTasks(),
          const SizedBox(height: 16),
          _buildContentsSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final userService = context.watch<UserProvider>();
    final dayCounter = context.watch<UserDayCounter>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${userService.userName}님, \n좋은 하루 되세요!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${dayCounter.daysSinceJoin}일째 되는 날',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTodayTasks() {
    final tasks = ['일일 과제1', '일일 과제2', '일일 과제3'];

    return _cardContainer(
      title: '오늘의 할일',
      trailing: const Icon(Icons.edit_outlined, size: 18),
      child: Column(
        children: List.generate(tasks.length, (index) {
          return Column(
            children: [
              _taskTile(tasks[index]),
            ],
          );
        }),
      ),
    );
  }

  Widget _taskTile(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_outlined, color: Colors.indigo),
          Expanded(
            child: Text(title)),
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(0, 32),
              ),
              child: const Text('수행하기',style: TextStyle(color: Colors.black)))
          ),
        ],
      ),
    );
  }
  
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
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      interval: 1,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const days = ['월', '화', '수', '목', '금', '토', '일'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(days[value.toInt()]),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
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

  Widget _buildContentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _contentCard(Icons.local_library, '    교육     '),            
            _contentCard(Icons.self_improvement, '호흡 명상'),
            _contentCard(Icons.edit_note, '걱정 일기'),
            _contentCard(Icons.healing, '노출 치료'),
          ],
        ),
      ],
    );
  }

  Widget _contentCard(IconData icon, String label) {
    return InkWell(
      onTap: () {
        if (label.trim() == '교육') {
          Navigator.pushNamed(context, '/education');
        } else if (label == '호흡 명상') {
          Navigator.pushNamed(context, '/breathing_meditation');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.indigo),
            const SizedBox(width: 6),
            Text(label)
          ],
        ),
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