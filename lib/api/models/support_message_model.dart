import 'package:cloud_firestore/cloud_firestore.dart';

class SupportMessageModel {
  final String id;
  final String message;
  final DateTime createdAt;

  SupportMessageModel({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory SupportMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print('################### data #######################');
    print(doc.id);
    return SupportMessageModel(
      id: doc.id,
      message: data['message'] as String,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
