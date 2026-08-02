import 'package:flutter_prakash/core.dart';

import '../entities/post.dart';

/// Contract for the post data source.
///
/// Clean Architecture **domain** layer.
abstract class PostRepository {
  /// Fetches the top [limit] posts. Returns a [Result] for downstream
  /// `Result`/`AsyncValue` handling.
  Future<Result<List<Post>>> fetchTopPosts(int limit);
}