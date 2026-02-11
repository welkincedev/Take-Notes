import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NotesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // Reference: users/{uid}/notes
  CollectionReference get notesRef =>
      _db.collection("users").doc(userId).collection("notes");

  // Add Note
  Future<void> addNote(String title, String content) async {
    final note = Note(id: "", title: title, content: content);

    await notesRef.add(note.toMap());
  }

  // Get Notes Stream
  Stream<List<Note>> getNotes() {
    return notesRef.orderBy("createdAt", descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) => Note.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }
}
