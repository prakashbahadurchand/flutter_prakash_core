import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/fetch_top_posts.dart';
import 'posts_state.dart';

/// Clean Architecture **application** layer for the posts feature.
class PostsCubit extends Cubit<PostsState> {
  final FetchTopPosts _fetchTopPosts;

  PostsCubit(this._fetchTopPosts) : super(const PostsInitial());

  Future<void> fetch({int limit = 3}) async {
    emit(const PostsLoading());
    final result = await _fetchTopPosts(limit);
    result.fold(
      onSuccess: (posts) => emit(PostsLoaded(posts)),
      onFailure: (failure) => emit(PostsError(failure.message)),
    );
  }
}