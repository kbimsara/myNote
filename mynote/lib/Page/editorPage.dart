import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final quill.QuillController _controller;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 👉  readOnly lives in the controller constructor
    _controller = quill.QuillController(
      document: quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: false,                // set true if you need read‑only mode
    );
  }

  void _save() {
    final jsonDelta = jsonEncode(_controller.document.toDelta().toJson());
    debugPrint('Saved JSON:\n$jsonDelta');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: Column(
        children: [
          // ─── Toolbar ───
          quill.QuillSimpleToolbar(controller: _controller),

          // ─── Editor ───
          Expanded(
            child: quill.QuillEditor(
              controller: _controller,
              focusNode: _focusNode,
              scrollController: _scrollController,
              // All the “missing” flags now sit in QuillEditorConfig 👇
              config: const quill.QuillEditorConfig(
                scrollable: true,
                autoFocus: true,
                expands: true,
                // readOnly: false, // set true if you need read‑only mode
                showCursor: true,
                padding: EdgeInsets.all(16),
                placeholder: 'Start writing…',
              ),
            ),
          ),
        ],
      ),
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
