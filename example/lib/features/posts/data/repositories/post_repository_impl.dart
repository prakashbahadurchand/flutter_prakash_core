import 'package:dio/dio.dart';
import 'package:flutter_prakash/core.dart';

import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/post_model.dart';

/// Clean Architecture **data** layer implementation of [PostRepository].
///
/// Maps transport concerns ([PostRemoteDataSource], DTOs) to the domain
/// contract and translates exceptions into [Failure] values.
class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _dataSource;

  PostRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Post>>> fetchTopPosts(int limit) async {
    try {
      final models = await _dataSource.fetchTopPosts(limit);
      return Result.success(models.map(_toEntity).toList());
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(UnknownFailure('Failed to load posts: $e'));
    }
  }

  Post _toEntity(PostModel model) => Post(
    id: model.id,
    userId: model.userId,
    title: model.title,
    body: model.body,
  );

  Failure _mapDioError(DioException e) {
    final status = e.response?.statusCode;
    if (status != null && status >= 500) {
      return ServerFailure('Server error ($status)', statusCode: status);
    }
    return NetworkFailure('Network error: ${e.message}');
  }
}