import '../repositories/note_repository.dart';

class GetNotes {
  const GetNotes(this._repository);
  final NoteRepository _repository;

  Future<FetchNotesResult> call() {
    return _repository.fetchNotes();
  }
}