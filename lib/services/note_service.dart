import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  // Add Note
  Future<void> addNote(String title, String content) async {
    await _firestore.collection("notes").add({
      "title": title,
      "content": content,
      "userId": uid,
      "createdAt": Timestamp.now(),
    });
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection("notes").doc(noteId).delete();
  }

  // Update Note
  Future<void> updateNote(String noteId, String title, String content) async {
    await _firestore.collection("notes").doc(noteId).update({
      "title": title,
      "content": content,
    });
  }

  // Stream Notes
  Stream<QuerySnapshot> getNotesStream() {
    return _firestore
        .collection("notes")
        .where("userId", isEqualTo: uid)
        .snapshots();
  }
}
