import 'package:flutter/material.dart';
import 'package:mynote/Models/dbHelper.dart';
import 'package:mynote/Page/homePage.dart';
import 'package:mynote/Page/noteViewPage.dart';
import 'package:mynote/Page/protectedNotePage.dart';

class NoteCard extends StatelessWidget {
  final String pg;
  final String Decs;
  final int noteId;

  const NoteCard({
    super.key,
    required this.Decs,
    required this.noteId,
    required this.pg,
  });
  // Show a dialog box/confirm the deletion of the user
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete User'),
            content: Text('Delete $Decs and all their modules?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    // final dbHelper = DatabaseHelper.instance;
                    final dbHelper = DatabaseHelper.instance;
                    await dbHelper.deleteNote(noteId);
                    if (context.mounted) {
                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User $Decs deleted')),
                      );
                    }
                    // Navigate to the MainApp page
                    if (pg == "Home") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProtectedNotePage()),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error deleting user'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber[50],
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteViewPage(noteId: noteId)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(child: Text(Decs, style: const TextStyle(fontSize: 17))),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
