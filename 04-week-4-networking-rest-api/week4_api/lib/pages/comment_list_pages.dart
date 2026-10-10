import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/comment_provider.dart';
import '../data/network_errors.dart';

class CommentListPage extends ConsumerStatefulWidget {
  final int postId;

  const CommentListPage({super.key, required this.postId});

  @override
  ConsumerState<CommentListPage> createState() => _CommentListPageState();
}

class _CommentListPageState extends ConsumerState<CommentListPage> {
  @override
  void initState() {
    super.initState();
    // Memanggil fetchComments secara otomatis begitu halaman pertama kali dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commentListProvider.notifier).fetchComments(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentAsync = ref.watch(commentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar untuk Post #${widget.postId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(commentListProvider.notifier).fetchComments(widget.postId);
            },
          ),
        ],
      ),
      body: commentAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  friendlyErrorMessage(error),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(commentListProvider.notifier).fetchComments(widget.postId);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (comments) {
          if (comments.isEmpty) {
            return const Center(
              child: Text('Belum ada komentar untuk post ini.'),
            );
          }

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${comment.id}'),
                  ),
                  title: Text(
                    comment.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        comment.email,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(comment.body),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}