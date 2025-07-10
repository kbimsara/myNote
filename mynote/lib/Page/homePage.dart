import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:mynote/Models/dbHelper.dart';

import '../Components/noteCard.dart';
import '../Models/noteModel.dart';
import 'editorPage.dart';
import 'lockPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _db = DatabaseHelper.instance;

  Future<void> _navigateAndRefresh(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    setState(() {}); // reload notes
  }

  // ↓— simplified: skip Delta, build Document directly —↓
  String _extractTitle(String deltaJson) {
    try {
      final doc = quill.Document.fromJson(
        jsonDecode(deltaJson) as List<dynamic>,
      );
      final text = doc.toPlainText().trim();
      if (text.isEmpty) return 'Untitled note';
      return text.length > 30 ? '${text.substring(0, 30)}…' : text;
    } catch (_) {
      return 'Untitled note';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text(
            'Your personal note‑taking app',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 55, 55, 55),
            ),
          ),
          SizedBox(
            height: 92,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _navigateAndRefresh(const LockPage(noteId: 1)),
                  child: const _MenuButton(icon: Icons.key_rounded),
                ),
                GestureDetector(
                  onTap: () => _navigateAndRefresh(const EditorPage()),
                  child: const _MenuButton(icon: Icons.edit_document),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Note>>(
              future: _db.getNotesByStatus(false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No notes yet'));
                }

                final notes = snapshot.data!;
                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      Decs: _extractTitle(note.noteDt),
                      noteId: note.noteId!,
                      pg: "home",
                      // isLocked: note.stat,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      height: 70,
      width: 122.94,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: 40, color: const Color.fromARGB(255, 55, 55, 55)),
    );
  }
}
