import 'package:flutter/material.dart';
import '../services/note_service.dart';

class EditNoteScreen extends StatefulWidget {
  final String noteId;
  final String oldTitle;
  final String oldContent;

  const EditNoteScreen({
    super.key,
    required this.noteId,
    required this.oldTitle,
    required this.oldContent,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  final NoteService noteService = NoteService();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.oldTitle);
    contentController = TextEditingController(text: widget.oldContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: "Content"),
              maxLines: 5,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await noteService.updateNote(
                  widget.noteId,
                  titleController.text.trim(),
                  contentController.text.trim(),
                );

                Navigator.pop(context);
              },
              child: const Text("Update Note"),
            ),
          ],
        ),
      ),
    );
  }
}
