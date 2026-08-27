import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/dashboard_feed_item_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/sample_item_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/sample_user_model.dart';

@lazySingleton
class DashboardRepository {
  final DashboardLocalDataSource _localDataSource;
  final DashboardRemoteDataSource _remoteDataSource;

  const DashboardRepository(this._localDataSource, this._remoteDataSource);

  FutureResult<DashboardStatsModel> getStats() {
    return Result.fromAsync(call: () => _localDataSource.getCachedStats());
  }

  FutureResult<List<DashboardFeedItemModel>> getHighlights() {
    return Result.fromAsync(call: () => _remoteDataSource.getHighlights());
  }

  FutureResult<List<String>> fetchFeatures() {
    return Result.fromAsync(call: () => _remoteDataSource.fetchSampleFeatures());
  }

  FutureResult<List<SampleUser>> fetchUsersPage({
    int page = 1,
    int pageSize = 10,
  }) {
    return Result.fromAsync(
      call: () => _remoteDataSource.fetchUsersPage(page: page, pageSize: pageSize),
    );
  }

  FutureResult<SampleItemModel> submitForm({
    required String title,
    required String description,
  }) {
    return Result.fromAsync(
      call: () => _remoteDataSource.submitForm(title: title, description: description),
    );
  }

  FutureResult<void> clearCache() {
    return Result.fromAsync(call: () => _localDataSource.clearCache());
  }
}
