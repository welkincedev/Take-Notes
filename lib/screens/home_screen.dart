import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../services/auth_service.dart';
import '../models/note_model.dart';
import 'edit_note_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteService noteService = NoteService();
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Neon Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditNoteScreen()),
          );
        },
      ),

      body: StreamBuilder<List<NoteModel>>(
        stream: noteService.getNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                "No notes yet.\nTap + to create one!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: ListTile(
                  title: Text(
                    note.title,
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditNoteScreen(note: note),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      noteService.deleteNote(note.id);
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
