import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_shizuya_weight_flutter/api/models/activity_report_model.dart';
import 'package:flutter/material.dart';

class ActivityReportScreen extends StatefulWidget {
  const ActivityReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityReportScreenState();
}

class _ActivityReportScreenState extends State<ActivityReportScreen> {
  List<ActivityReportModel> activityReports = [];
  late FirebaseFirestore firestore;
  late CollectionReference<Map<String, dynamic>> collection;

  Future<void> fetchMessages() async {
    final snapshot = await collection.get();
    setState(() {
      activityReports = snapshot.docs
          .map((doc) => ActivityReportModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    collection = firestore.collection('activity_report');
    fetchMessages();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDate(DateTime date) {
    return '${date.year}年${date.month}月${date.day}日';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('活動報告'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final item = activityReports[index];
          final isNewDay = index == 0 ||
              !_isSameDay(item.createdAt, activityReports[index - 1].createdAt);

          return Column(
            children: [
              if (isNewDay)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: Colors.grey.shade100,
                  child: Text(
                    _formatDate(item.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Text(item.activity),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        itemCount: activityReports.length,
      ),
    );
  }
}
