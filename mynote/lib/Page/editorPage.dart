import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

void main() {
  runApp(const EditorPage());
}

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

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
              "Text Editor",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 55, 55, 55),
              ),
            ),
          ),
          // Editor area
          SizedBox(
            height: 92,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Code here
                quill.QuillEditor.basic(
                  controller: _controller,
                  toolbar: quill.QuillToolbar.basic(),
                  readOnly: false,
                  // readOnly: false,
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
