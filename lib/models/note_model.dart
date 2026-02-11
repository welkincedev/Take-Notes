import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final Timestamp createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    return NoteModel(
      id: doc.id,
      title: doc["title"],
      content: doc["content"],
      createdAt: doc["createdAt"],
    );
  }
}
