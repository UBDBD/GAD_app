import 'package:flutter/material.dart';

class UserDayCounter extends ChangeNotifier {
  DateTime? _createdAt;

  void setCreatedAt(DateTime date) {
    _createdAt = date;
    notifyListeners();
  }

  int get daysSinceJoin {
    if (_createdAt == null) return 0;
    return DateTime.now().difference(_createdAt!).inDays + 1;
  }
}