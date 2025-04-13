import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDatabase {
  static Future<void> saveSurveyResult({
    required List<String> worries,
    String? otherWorry,
    required String? sleepHours,
    required String? sleepQuality,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final surveyData = {
      'worries': worries,
      'otherWorry': otherWorry,
      'sleepHours': sleepHours,
      'sleepQuality': sleepQuality,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('surveys')
        .add(surveyData);

    await markSurveyCompleted();
  }

  static Future<void> markSurveyCompleted() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'hasCompletedSurvey': true,
    }, SetOptions(merge: true));
  }

  static Future<bool> hasCompletedSurvey() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['hasCompletedSurvey'] == true;
  }
} 
