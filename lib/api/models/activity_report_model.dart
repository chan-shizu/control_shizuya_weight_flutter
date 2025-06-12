import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityReportModel {
  final String id;
  final String activity;
  final DateTime createdAt;

  ActivityReportModel({
    required this.id,
    required this.activity,
    required this.createdAt,
  });

  factory ActivityReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityReportModel(
      id: doc.id,
      activity: data['activity'] as String,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'activity': activity,
      'created_at': createdAt,
    };
  }
}
