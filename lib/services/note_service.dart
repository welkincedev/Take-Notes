import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note_model.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get uid => FirebaseAuth.instance.currentUser?.uid;

  // ✅ Add Note
  Future<void> addNote(String title, String content) async {
    await _db.collection("users").doc(uid).collection("notes").add({
      "title": title,
      "content": content,
      "createdAt": Timestamp.now(),
    });
  }

  // ✅ Update Note
  Future<void> updateNote(String id, String title, String content) async {
    await _db.collection("users").doc(uid).collection("notes").doc(id).update({
      "title": title,
      "content": content,
    });
  }

  // ✅ Delete Note
  Future<void> deleteNote(String id) async {
    await _db.collection("users").doc(uid).collection("notes").doc(id).delete();
  }

  // ✅ Stream Notes
  Stream<List<NoteModel>> getNotes() {
    return _db
        .collection("users")
        .doc(uid)
        .collection("notes")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => NoteModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
}
