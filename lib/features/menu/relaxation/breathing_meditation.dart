import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 호흡 명상 페이지
class BreathingMeditationPage extends StatefulWidget {
  const BreathingMeditationPage({super.key});

  @override
  State<BreathingMeditationPage> createState() => _BreathingMeditationPageState();
}

class _BreathingMeditationPageState extends State<BreathingMeditationPage>
    with SingleTickerProviderStateMixin {
  // 설정된 타이밍 상수
  static const int inhaleDuration = 2;   
  static const int exhaleDuration = 3;     
  static const int prepDuration = 5;       
  static const int totalSeconds = 10;      

  // 상태 변수
  int _secondsLeft = totalSeconds;
  int _prepCountdown = prepDuration;
  bool _isInhale = true;
  bool _isStarted = false;
  int _phaseSeconds = inhaleDuration;

  // 애니메이션
  late final AnimationController _animationController;
  late final Animation<double> _sizeAnimation;

  // 타이머들
  Timer? _prepTimer;
  Timer? _phaseTimer;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤 초기화
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: inhaleDuration),
    );

    // 원 사이즈 애니메이션 설정
    _sizeAnimation = Tween<double>(begin: 200, end: 300).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 준비 카운트다운 시작
    _startPrepCountdown();
  }

  /// 준비 시간 카운트다운 → 끝나면 명상 시작
  void _startPrepCountdown() {
    _prepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prepCountdown <= 1) {
        timer.cancel();
        _startMeditation();
      } else {
        setState(() => _prepCountdown--);
      }
    });
  }

  /// 명상 시작: 타이머 및 애니메이션 설정
  void _startMeditation() {
    setState(() {
      _isStarted = true;
      _isInhale = true;
      _phaseSeconds = inhaleDuration;
    });

    _animationController.duration = const Duration(seconds: inhaleDuration);
    _animationController.forward();

    _startPhaseTimer();     // 들숨/날숨 전환 타이머
    _startCountdownTimer(); // 전체 명상 시간 타이머
  }

  /// 들숨 ↔ 내숨 전환용 타이머
  void _startPhaseTimer() {
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_phaseSeconds <= 1) {
        setState(() {
          _isInhale = !_isInhale;
          _phaseSeconds = _isInhale ? inhaleDuration : exhaleDuration;
        });

        _animationController.duration = Duration(seconds: _phaseSeconds);
        _isInhale ? _animationController.forward() : _animationController.reverse();
        HapticFeedback.mediumImpact(); // 진동 피드백
      } else {
        setState(() => _phaseSeconds--);
      }
    });
  }

  /// 전체 명상 시간 카운트다운
  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        _stopSession();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  /// 명상 종료 → 다이얼로그 표시 후 근육 이완 페이지로 이동
  void _stopSession() {
    _phaseTimer?.cancel();
    _countdownTimer?.cancel();
    _animationController.stop();

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('호흡 명상 완료'),
          content: const Text('점진적 근육 이완을 시작하겠습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/muscle_relaxation'),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _prepTimer?.cancel();
    _phaseTimer?.cancel();
    _countdownTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  /// 원 애니메이션 위젯 (들이쉴 때 확대, 내쉴 때 축소)
  Widget _buildBreathingCircle() {
    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return Container(
          width: _sizeAnimation.value,
          height: _sizeAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.indigo.shade100,
                Colors.indigo,
                Colors.indigo,
              ],
              center: Alignment.center,
              radius: 0.85,
            ),
          ),
          child: const Center(
            child: Icon(Icons.self_improvement, size: 100, color: Colors.white),
          ),
        );
      },
    );
  }

  /// 안내 문구 위젯 (들숨/날숨 텍스트, 준비 카운트다운 등)
  Widget _buildInstructionText() {
    if (!_isStarted) {
      return Column(
        children: [
          const Text(
            '시작 전 준비해주세요',
            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('시작까지 $_prepCountdown초', style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      );
    } else {
      return Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _isInhale ? '들이쉬세요' : '내쉬세요',
              key: ValueKey<bool>(_isInhale),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
          ),
          const SizedBox(height: 16),
          Text('남은 시간: $_phaseSeconds초', style: const TextStyle(color: Colors.grey)),
        ],
      );
    }
  }

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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        titleSpacing: 6,
        title: const Text('호흡 명상', style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBreathingCircle(),
            const SizedBox(height: 32),
            _buildInstructionText(),
          ],
        ),
      ),
    );
  }
}