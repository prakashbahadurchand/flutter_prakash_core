import 'package:flutter_prakash/flutter_prakash.dart';

import '../models/post_model.dart';

/// Remote source that talks to the REST endpoint through the plug-in's
/// [DioClient].
///
/// Clean Architecture **data** layer: the only component aware of the raw
/// network transport.
class PostRemoteDataSource {
  final DioClient _client;

  PostRemoteDataSource(this._client);

  Future<List<PostModel>> fetchTopPosts(int limit) async {
    final response = await _client.dio.get('/posts?_limit=$limit');
    final list = response.data as List;
    return list
        .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}