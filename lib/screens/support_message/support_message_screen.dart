import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/models/support_message_model.dart';

class SupportMessageScreen extends StatefulWidget {
  const SupportMessageScreen({super.key});

  @override
  State<SupportMessageScreen> createState() => _SupportMessageScreenState();
}

class _SupportMessageScreenState extends State<SupportMessageScreen> {
  final _messageController = TextEditingController();
  List<SupportMessageModel> messages = [];
  late FirebaseFirestore firestore;
  late CollectionReference<Map<String, dynamic>> collection;

  @override
  void initState() {
    super.initState();

    firestore = FirebaseFirestore.instance;
    collection = firestore.collection('support_message');

    watch();
  }

  // データ更新監視
  Future<void> watch() async {
    collection.snapshots().listen((event) {
      if (mounted) {
        setState(() {
          messages = event.docs
              .map(
                (document) => SupportMessageModel.fromFirestore(document),
              )
              .toList(growable: false)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        });
      }
    });
  }

  // firestoreにメッセージを追加
  Future<void> addMessage(String messageText) async {
    try {
      final message = SupportMessageModel(
        id: '', // Firestoreが自動生成
        message: messageText,
        createdAt: DateTime.now(),
      );

      await collection.add(message.toFirestore());
      _messageController.clear();
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('メッセージの送信に失敗しました'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サポートメッセージ'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final item = messages[index];
                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.message,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('yyyy/MM/dd HH:mm').format(item.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: messages.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'メッセージを入力してください',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      controller: _messageController,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await addMessage(_messageController.text);
                      },
                      child: const Text('送信'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: SizedBox(width: 60, height: 60, child: const Icon(Icons.add)),
        shape: const CircleBorder(),
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final SupportMessageModel message;

  const MessageCard({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          message.message,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(dateFormat.format(message.createdAt)),
      ),
    );
  }
}
