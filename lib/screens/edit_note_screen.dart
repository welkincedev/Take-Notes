import 'package:flutter/material.dart';
import '../services/note_service.dart';
import '../models/note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel? note;

  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final NoteService _noteService = NoteService();

  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note?.title ?? "");
    contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  void saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    if (widget.note != null) {
      await _noteService.updateNote(widget.note!.id, title, content);
    } else {
      await _noteService.addNote(title, content);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? "Edit Note" : "New Note"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: contentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Write your note...",
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
