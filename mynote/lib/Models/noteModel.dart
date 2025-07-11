class Note {
  final int? noteId;
  final String noteDt;
  final bool stat;

  Note({
    this.noteId,
    required this.noteDt,
    required this.stat,
  });

  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'noteDt': noteDt,
      'stat': stat ? 1 : 0,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      noteId: map['noteId'],
      noteDt: map['noteDt'],
      stat: (map['stat'] as int) == 1,
    );
  }
}