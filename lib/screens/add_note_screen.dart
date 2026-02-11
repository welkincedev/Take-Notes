import 'package:flutter/material.dart';
import '../services/notes_service.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final NotesService notesService = NotesService();

  void saveNote() async {
    await notesService.addNote(
      titleController.text.trim(),
      contentController.text.trim(),
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveNote, child: const Text("Save Note")),
          ],
        ),
      ),
    );
  }
}
