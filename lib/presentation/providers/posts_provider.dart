import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/remote/network/dio_client.dart';
import '../../data/remote/service/post_service.dart';
import '../../domain/model/post.dart';
import '../../data/remote/dto/post_dto.dart';

final dioProvider = Provider<Dio>((_) => buildDioClient());

final postServiceProvider = Provider<PostService>(
      (ref) => PostService(ref.watch(dioProvider)),
);

class PostsNotifier extends AsyncNotifier<List<Post>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  Future<List<Post>> build() => _fetchPage(1);

  Future<List<Post>> _fetchPage(int page) async {
    final service = ref.read(postServiceProvider);
    try {
      final dtos = await service.fetchPosts(page: page, limit: 15);
      _hasMore = dtos.length == 15;
      return dtos.map((d) => d.toDomain()).toList();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> fetchNextPage() async {
    if (!_hasMore) return;
    final current = state.valueOrNull ?? [];
    _page++;
    try {
      final newPosts = await _fetchPage(_page);
      state = AsyncValue.data([...current, ...newPosts]);
    } on AppError catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(1));
  }
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<Post>>(
  PostsNotifier.new,
);