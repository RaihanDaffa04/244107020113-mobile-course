import '../../../../core/failures.dart';
import '../entities/note.dart';

typedef FetchNotesResult = ({List<Note> notes, Failure? failure});
typedef AddNoteResult = ({Note? note, Failure? failure});

abstract interface class NoteRepository {
  Future<FetchNotesResult> fetchNotes();

  Future<AddNoteResult> addNote({required String title, String body = ''});

  Future<void> deleteNote(int id);

  Future<int> countDirty();

  Future<Note?> fetchNoteById(int id);

  Future<void> updateNote(
    int id, {
    required String title,
    required String body,
  });

  Future<void> markAllSynced();
}