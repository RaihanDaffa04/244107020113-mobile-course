import '../../../../core/format.dart';
import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    super.id,
    required super.title,
    super.body = '',
    required super.updatedAt,
    super.dirty = false,
  });

  @override
  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'updated_at': updatedAt.toIso8601String(),
        'dirty': dirty ? 1 : 0,
      };

  factory NoteModel.fromMap(Map<String, Object?> map) {
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

    return NoteModel(
      id: id,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      updatedAt: parseStoredDateTime(map['updated_at']),
      dirty: dirty,
    );
  }

  Note toEntity() => Note(
        id: id,
        title: title,
        body: body,
        updatedAt: updatedAt,
        dirty: dirty,
      );
}