import 'package:cloud_firestore/cloud_firestore.dart';

class WeightModel {
  final String id;
  final double weight;
  final DateTime createdAt;

  WeightModel({
    required this.id,
    required this.weight,
    required this.createdAt,
  });

  factory WeightModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WeightModel(
      id: doc.id,
      weight: data['weight'] as double,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'weight': weight,
      'created_at': createdAt,
    };
  }
}
