import 'package:flutter/material.dart';

class UserDayCounter extends ChangeNotifier {
  DateTime? _createdAt;

  /// 가입일 설정
  void setCreatedAt(DateTime date) {
    _createdAt = date;
    notifyListeners();
  }

  /// 가입일 초기화
  void reset() {
    _createdAt = null;
    notifyListeners();
  }

  /// 가입일이 설정되어 있는지 확인
  bool get isInitialized => _createdAt != null;

  /// 가입일 기준 며칠 째인지 반환
  int get daysSinceJoin {
    if (_createdAt == null) return 0;
    final today = DateTime.now();
    return today.difference(_createdAt!).inDays + 1;
  }

  /// 가입일 직접 접근 (읽기 전용)
  DateTime? get createdAt => _createdAt;
}