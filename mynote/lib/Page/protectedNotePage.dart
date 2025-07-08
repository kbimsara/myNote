import 'package:flutter/material.dart';
import 'package:mynote/Components/noteCard.dart';
import 'package:mynote/Page/homePage.dart';
import 'package:mynote/Page/lockPage.dart';

void main() {
  runApp(const ProtectedNotePage());
}

class ProtectedNotePage extends StatelessWidget {
  const ProtectedNotePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(20.0)),
          // header text
          Container(
            child: const Text(
              "Protected Notes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 55, 55),
              ),
            ),
          ),
          // note cards
          Expanded(
            // ← fills remaining space
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: const [
                  NoteCard(title: 'Note 1', noteId: 1),
                  NoteCard(title: 'Note 2', noteId: 2),
                  NoteCard(title: 'Note 3', noteId: 3),
                  NoteCard(title: 'Note 4', noteId: 4),
                  NoteCard(title: 'Note 5', noteId: 5),
                  NoteCard(title: 'Note 6', noteId: 6),
                  NoteCard(title: 'Note 7', noteId: 7),
                  NoteCard(title: 'Note 8', noteId: 8),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: _showAddDialog,
        backgroundColor: const Color.fromARGB(255, 255, 145, 0),
        icon: const Icon(Icons.lock, color: Colors.white),
        label: const Text('Lock', style: TextStyle(color: Colors.white)),
        tooltip: 'Lock', onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
