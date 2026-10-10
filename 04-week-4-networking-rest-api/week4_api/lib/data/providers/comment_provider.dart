import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment.dart';
import '../repositories/comment_repository.dart';

final commentDioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository(ref.watch(commentDioProvider));
});

class CommentNotifier extends AsyncNotifier<List<Comment>> {
  @override
  Future<List<Comment>> build() async {
    // Default kembalian awal jika diperlukan, atau bisa dikosongkan/mengambil data default
    return [];
  }

  // Metode untuk mengambil komentar berdasarkan postId dipanggil manual dari UI
  Future<void> fetchComments(int postId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(commentRepositoryProvider).fetchComments(postId),
    );
  }
}

final commentListProvider = AsyncNotifierProvider<CommentNotifier, List<Comment>>(
  CommentNotifier.new,
);
