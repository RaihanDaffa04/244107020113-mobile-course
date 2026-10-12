import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/failures.dart';
import '../../../../widgets/note_editor_dialog.dart';
import '../../../../widgets/note_tile.dart';
import '../providers/notes_providers.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  Future<void> _addNote(BuildContext context, WidgetRef ref) async {
    final draft = await NoteEditorDialog.show(
      context,
      dialogTitle: 'Catatan baru',
    );
    if (draft == null || !context.mounted) return;

    try {
      await ref.read(noteRepositoryProvider).addNote(
        title: draft.title,
        body: draft.body,
      );
      ref.invalidate(notesProvider);
      ref.invalidate(dirtyCountProvider);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan catatan: ${toUserMessage(error)}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesProvider);
    final dirtyCount = ref.watch(dirtyCountProvider);

    return state.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Catatan')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat catatan: ${toUserMessage(error)}'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(notesProvider),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ),
      data: (notes) => Scaffold(
        appBar: AppBar(
          title: const Text('Catatan'),
          actions: [
            dirtyCount.maybeWhen(
              data: (count) => count > 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Badge(
                        label: Text('$count'),
                        child: const Icon(Icons.sync_problem),
                      ),
                    )
                  : const Icon(Icons.cloud_done),
              orElse: () => const SizedBox(width: 40, height: 40),
            ),
          ],
        ),
        body: notes.isEmpty
            ? const Center(child: Text('Belum ada catatan.'))
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteTile(
                    note: note,
                    onTap: note.id != null
                        ? () => context.push('/note/${note.id}')
                        : null,
                    onDelete: () async {
                      if (note.id == null) return;

                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus catatan?'),
                          content: Text('Catatan "${note.title}" akan dihapus.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (shouldDelete != true || !context.mounted) return;

                      try {
                        await ref.read(noteRepositoryProvider).deleteNote(note.id!);
                        ref.invalidate(notesProvider);
                        ref.invalidate(dirtyCountProvider);
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Gagal menghapus catatan: ${toUserMessage(error)}',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addNote(context, ref),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}