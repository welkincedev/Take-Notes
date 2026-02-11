import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/note_service.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final NoteService noteService = NoteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Take Notes"), centerTitle: true),

      // Add Button
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNoteScreen()),
          );
        },
      ),

      // Notes List
      body: StreamBuilder<QuerySnapshot>(
        stream: noteService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!.docs;

          if (notes.isEmpty) {
            return const Center(child: Text("No notes yet. Tap + to add one."));
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(note["title"]),
                  subtitle: Text(
                    note["content"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Tap → Edit
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditNoteScreen(
                          noteId: note.id,
                          oldTitle: note["title"],
                          oldContent: note["content"],
                        ),
                      ),
                    );
                  },

                  // Delete Button
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await noteService.deleteNote(note.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
