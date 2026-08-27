import 'package:flutter_prakash_core_example/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DashboardLocalDataSource {
  const DashboardLocalDataSource();

  Future<DashboardStatsModel> getCachedStats() async {
    return const DashboardStatsModel(
      architecture: 'Clean Core',
      diContainer: 'GetIt Ready',
      activePluginsCount: 16,
      isEngineOnline: true,
    );
  }

  Future<void> clearCache() async {
    // Clear temporary cached preferences if any
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
