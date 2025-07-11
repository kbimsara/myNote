import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:mynote/Models/dbHelper.dart';
import 'package:mynote/Page/homePage.dart';
import '../Models/noteModel.dart'; // adjust if your path differs

class NoteViewPage extends StatefulWidget {
  final int noteId;

  const NoteViewPage({super.key, required this.noteId});

  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  late quill.QuillController _controller;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final db = DatabaseHelper.instance;

  bool _isLoading = true;
  bool _isLocked = false; // current stat

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  /// Fetch the note from DB and initialise the editor
  Future<void> _loadNote() async {
    final note = await db.getNoteById(widget.noteId);
    if (note == null) {
      if (mounted) Navigator.pop(context); // note not found
      return;
    }

    _isLocked = note.stat;

    final jsonDelta = jsonDecode(note.noteDt) as List<dynamic>;
    final document = quill.Document.fromJson(jsonDelta);

    _controller = quill.QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      // readOnly: _isLocked,
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// Save current editor content back to SQLite
  Future<void> _save() async {
    final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
    await db.updateNoteContent(widget.noteId, deltaJson);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Note updated')));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  /// Toggle lock/unlock
  Future<void> _toggleLock() async {
    // bool status = false;
    final note2 = await db.getNoteById(widget.noteId);

    if (note2 == null) {
      if (mounted) Navigator.pop(context); // note not found
      return;
    } else {
      bool status = note2.stat;
      status = !status;
      await db.updateNoteStatus(widget.noteId, status);
    }

    // print('local-${status} : desc ${note.noteDt}: status- ${note.stat}');

    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_isLocked ? 'Locked' : 'Unlocked')));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('View / Edit Note'),
        actions: [
          IconButton(
            icon: Icon(_isLocked ? Icons.lock_open : Icons.lock),
            onPressed: _toggleLock,
          ),
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
              config: quill.QuillEditorConfig(
                scrollable: true,
                autoFocus: true,
                expands: true,
                showCursor: true,
                padding: const EdgeInsets.all(16),
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
    super.dispose();
  }
}
