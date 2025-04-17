import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 근육 이완 명상 페이지
/// - 각 부위마다 수축(2초), 이완(3초)을 반복하여 전체 몸을 이완시킴
class MuscleRelaxationPage extends StatefulWidget {
  const MuscleRelaxationPage({super.key});

  @override
  State<MuscleRelaxationPage> createState() => _MuscleRelaxationPageState();
}

class _MuscleRelaxationPageState extends State<MuscleRelaxationPage>
    with SingleTickerProviderStateMixin {
  // 이완 단계
  final List<Map<String, String>> steps = [
    {'title': '팔꿈치 아래', 'description': '주먹을 꽉 쥐고 손목을 몸 쪽으로 굽혀주세요.'},
    {'title': '팔꿈치 윗부분', 'description': '손목을 어깨 쪽으로 조여 팔꿈치를 긴장시켜주세요.'},
    {'title': '무릎 아래', 'description': '다리를 들어 발끝을 몸 쪽으로 당겨주세요.'},
    {'title': '배', 'description': '배를 힘껏 조여 긴장시켜주세요.'},
    {'title': '가슴', 'description': '깊게 숨을 들이쉬며 가슴에 힘을 주세요.'},
    {'title': '어깨', 'description': '어깨를 귀 쪽으로 힘껏 올리세요.'},
    {'title': '목', 'description': '턱을 가슴 쪽으로 당겨 목 근육을 긴장시켜주세요.'},
    {'title': '얼굴', 'description': '입술을 다물고 얼굴 전체에 힘을 주세요.'},
  ];

  // 각 단계의 시간 설정
  final int contractDuration = 2;
  final int relaxDuration = 3;
  final int prepDuration = 5;

  int _currentStep = 0;
  int _prepCountdown = 0;
  int _phaseTime = 0;

  bool _isContracting = true;
  bool _isStarted = false;

  Timer? _prepTimer;
  Timer? _phaseTimer;

  late final AnimationController _animationController;
  late final Animation<double> _iconSizeAnimation;

  @override
  void initState() {
    super.initState();
    
    _prepCountdown = prepDuration;
    
    // 아이콘 크기 애니메이션 설정
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _iconSizeAnimation = Tween<double>(begin: 200, end: 300).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 시작 전 준비 카운트다운
    _startPrepCountdown();
  }

  /// 준비 카운트다운
  void _startPrepCountdown() {
    _prepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prepCountdown <= 1) {
        timer.cancel();
        _startRelaxation();
      } else {
        setState(() => _prepCountdown--);
      }
    });
  }

  /// 이완 시작
  void _startRelaxation() {
    setState(() {
      _isStarted = true;
      _isContracting = true;
      _phaseTime = contractDuration;
    });

    _updateAnimationDuration(contractDuration);
    _animationController.forward();

    // 수축/이완 전환 타이머
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _phaseTime--);

      if (_phaseTime <= 0) {
        _isContracting ? _switchToRelaxation() : _advanceToNextStepOrFinish();
      }
    });
  }

  /// 수축 → 이완 전환
  void _switchToRelaxation() {
    setState(() {
      _isContracting = false;
      _phaseTime = relaxDuration;
    });

    _updateAnimationDuration(relaxDuration);
    _animationController.reverse();
    HapticFeedback.mediumImpact();
  }

  /// 다음 단계로 이동 또는 종료 처리
  void _advanceToNextStepOrFinish() {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
        _isContracting = true;
        _phaseTime = contractDuration;
      });

      _updateAnimationDuration(contractDuration);
      _animationController.forward();
    } else {
      _phaseTimer?.cancel();
      _showFinishDialog();
    }
  }

  /// 애니메이션 지속시간 업데이트
  void _updateAnimationDuration(int seconds) {
    _animationController.duration = Duration(seconds: seconds);
  }

  /// 종료 안내 다이얼로그
  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('근육 이완 완료'),
        content: const Text('이제 당신의 호흡은 규칙적이고,\n온몸은 이완되고 편안함을 느낍니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/contents', (_) => false),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _prepTimer?.cancel();
    _phaseTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = steps[_currentStep];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('근육 이완', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
          ),
        ],
      ),
      body: Center(
        child: !_isStarted ? _buildPreparationView() : _buildRelaxationView(current),
      ),
    );
  }

  /// 준비 단계 뷰 (시작 전)
  Widget _buildPreparationView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.accessibility_new, size: 200, color: Colors.indigo),
        const SizedBox(height: 16),
        const Text('시작 전 준비해주세요.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text('시작까지 $_prepCountdown초', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// 근육 수축/이완 단계 뷰
  Widget _buildRelaxationView(Map<String, String> current) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 부위명 + 설명
        Text(current['title']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            current['description']!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),

        const SizedBox(height: 24),

        // 아이콘 애니메이션
        AnimatedBuilder(
          animation: _iconSizeAnimation,
          builder: (context, child) {
            return Icon(
              Icons.accessibility_new,
              size: _iconSizeAnimation.value,
              color: _isContracting ? Colors.red.shade300 : Colors.indigo.shade300,
            );
          },
        ),

        const SizedBox(height: 32),

        // 안내 문구
        Text(
          _isContracting ? '수축하세요' : '이완하세요',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _isContracting ? Colors.red : Colors.indigo,
          ),
        ),

        const SizedBox(height: 16),
        Text('남은 시간: $_phaseTime초', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}