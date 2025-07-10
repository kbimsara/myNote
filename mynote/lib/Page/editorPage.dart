import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:mynote/Models/dbHelper.dart';
import '../Models/noteModel.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final quill.QuillController _controller;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final db = DatabaseHelper.instance;

  int? _noteId;

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController(
      document: quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: false,
    );
  }

  Future<void> setNote() async {
    final deltaJson = jsonEncode(_controller.document.toDelta().toJson());

    final note = Note(
      noteDt: deltaJson, // note content (not datetime)
      stat: false,
    );

    _noteId = await db.createNote(note);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Note saved successfully')));
  }

  void _save() async => await setNote();

  void _lock() async {
    if (_noteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please save before locking')),
      );
      return;
    }

    await db.updateNoteStatus(_noteId!, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note locked')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Editor"),
        actions: [
          IconButton(icon: const Icon(Icons.lock), onPressed: _lock),
        ],
      ),
      body: Column(
        children: [
          quill.QuillSimpleToolbar(controller: _controller),
          Expanded(
            child: quill.QuillEditor(
              controller: _controller,
              focusNode: _focusNode,
              scrollController: _scrollController,
              config: const quill.QuillEditorConfig(
                scrollable: true,
                autoFocus: true,
                expands: true,
                showCursor: true,
                padding: EdgeInsets.all(16),
                placeholder: 'Start writing your note…',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 255, 145, 0),
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text('Save', style: TextStyle(color: Colors.white)),
        tooltip: 'Save',
        onPressed: _save,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
