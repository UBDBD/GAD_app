import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_daycounter.dart';

class UserProvider extends ChangeNotifier {
  String _userName = '사용자';
  String get userName => _userName;

  String _userEmail = '';
  String get userEmail => _userEmail;

  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;

  Future<void> fetchUserName({UserDayCounter? dayCounter}) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;
      final uid = refreshedUser?.uid;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();

      _userName = data?['name'] ?? refreshedUser?.displayName ?? '사용자';
      _userEmail = refreshedUser?.email ?? '';

      if (data?['createdAt'] != null && data!['createdAt'] is Timestamp) {
        _createdAt = (data['createdAt'] as Timestamp).toDate();

        if (dayCounter != null) {
          dayCounter.setCreatedAt(_createdAt!);
        }
      }

      notifyListeners();
    }
  }

  void updateUserName(String name) {
    _userName = name;
    notifyListeners();
  }
}