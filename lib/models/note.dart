class Note {
  final String id;
  final String? title;
  final String userId;
  final String content;
  final String createdAt;

  Note({
    required this.id,
    required this.title,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  Note copyWith({String? content}) {
    return Note(
      id: id,
      title: title,
      userId: userId,
      content: content ?? this.content,
      createdAt: createdAt,
    );
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    // title peut venir comme null, 'null', 'NULL' ou ''
    String? rawTitle;
    if (map.containsKey('title')) {
      final t = map['title'];
      if (t == null) {
        rawTitle = null;
      } else {
        final ts = t.toString().trim();
        if (ts.isEmpty || ts.toLowerCase() == 'null') {
          rawTitle = null;
        } else {
          rawTitle = ts;
        }
      }
    } else {
      rawTitle = null;
    }
    return Note(
      id: map['id'].toString(),
      userId: map['userId'].toString(),
      title: rawTitle,
      content: map['content']?.toString() ?? '',
      createdAt:
          map['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
