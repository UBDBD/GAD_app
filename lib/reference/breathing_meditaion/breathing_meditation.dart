import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class BreathingMeditationPage extends StatefulWidget {
  const BreathingMeditationPage({super.key});

  @override
  State<BreathingMeditationPage> createState() => _BreathingMeditationPageState();
}

class _BreathingMeditationPageState extends State<BreathingMeditationPage>
    with SingleTickerProviderStateMixin {
  static const int totalSeconds = 10;
  static const int interval = 5;

  int _secondsLeft = totalSeconds;
  int _prepCountdown = 5;
  bool _isInhale = true;
  bool _isStarted = false;

  late final AnimationController _animationController;
  late final Animation<double> _sizeAnimation;

  Timer? _prepTimer;
  Timer? _breathingTimer;
  Timer? _countdownTimer;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: interval),
    );

    _sizeAnimation = Tween<double>(begin: 200, end: 300).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startPrepCountdown();
  }

  void _startPrepCountdown() {
    _prepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prepCountdown <= 1) {
        _prepTimer?.cancel();
        _startMeditation();
      } else {
        setState(() {
          _prepCountdown--;
        });
      }
    });
  }

  void _startMeditation() {
    setState(() {
      _isStarted = true;
      _isInhale = true;
    });

    _animationController.forward();

    _breathingTimer = Timer.periodic(const Duration(seconds: interval), (_) {
      setState(() {
        _isInhale = !_isInhale;
      });
      _isInhale ? _animationController.forward() : _animationController.reverse();
      HapticFeedback.mediumImpact();
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        _stopSession();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _stopSession() {
    _breathingTimer?.cancel();
    _countdownTimer?.cancel();
    _animationController.stop();
    player.stop();

    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('명상이 완료되었습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/breathing_meditation'),
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
    _breathingTimer?.cancel();
    _countdownTimer?.cancel();
    _animationController.dispose();
    player.dispose();
    super.dispose();
  }

  Widget buildBreathingCircle() {
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

  Widget buildInstructionText() {
    if (!_isStarted) {
      return Column(
        children: [
          const Text(
            '명상 시작 전 준비해주세요',
            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            '시작까지 $_prepCountdown초',
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 32,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _isInhale ? '들이쉬세요' : '내쉬세요',
                key: ValueKey<bool>(_isInhale),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '남은 시간: $_secondsLeft초',
            style: const TextStyle(color: Colors.grey),
          ),
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
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/breathing_meditation', (route) => false),
          ),
        ),
        titleSpacing: 6,
        title: Row(
          children: const [
            Text('호흡 명상', style: TextStyle(color: Colors.black)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.black),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildBreathingCircle(),
            const SizedBox(height: 32),
            buildInstructionText(),
          ],
        ),
      ),
    );
  }
}
