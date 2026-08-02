import 'package:flutter_prakash/core.dart';

import '../entities/post.dart';
import '../repositories/post_repository.dart';

/// Use case that fetches the top posts.
///
/// Clean Architecture **domain** layer.
class FetchTopPosts {
  final PostRepository repository;

  const FetchTopPosts(this.repository);

  Future<Result<List<Post>>> call(int limit) =>
      repository.fetchTopPosts(limit);
}