import 'package:flutter/material.dart';
import 'package:mynote/Components/noteCard.dart';
import 'package:mynote/Page/editorPage.dart';
import 'package:mynote/Page/lockPage.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              "Your personal note-taking app",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 55, 55),
              ),
            ),
          ),
          // top 2 button
          SizedBox(
            height: 92,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LockPage(noteId: 1)),
                  ),
                  child: Container(
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
                    child: const Icon(
                      Icons.key_rounded,
                      size: 40,
                      color: Color.fromARGB(255, 55, 55, 55),
                    ),
                    // child: Text(
                    //   "Valt",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromARGB(255, 55, 55, 55),
                    //   ),
                    // ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditorPage()),
                  ),
                  child: Container(
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
                    child: const Icon(
                      Icons.book_online,
                      size: 40,
                      color: Color.fromARGB(255, 55, 55, 55),
                    ),
                  ),
                ),
              ],
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
    );
  }
}
