import '../../../../core/format.dart';

class Note {
  const Note({
    this.id,
    required this.title,
    this.body = '',
    required this.updatedAt,
    this.dirty = false,
  });

  final int? id;
  final String title;
  final String body;
  final DateTime updatedAt;
  final bool dirty;

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'updated_at': updatedAt.toIso8601String(),
        'dirty': dirty ? 1 : 0,
      };

  factory Note.fromMap(Map<String, Object?> map) {
    final rawId = map['id'];
    final id = switch (rawId) {
      int value => value,
      String value => int.tryParse(value),
      num value => value.toInt(),
      _ => null,
    };

    final dirtyValue = map['dirty'];
    final dirty = switch (dirtyValue) {
      bool value => value,
      int value => value == 1,
      num value => value.toInt() == 1,
      String value => value == '1' || value.toLowerCase() == 'true',
      _ => false,
    };

    return Note(
      id: id,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      updatedAt: parseStoredDateTime(map['updated_at']),
      dirty: dirty,
    );
  }
}