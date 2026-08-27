import 'package:flutter/material.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/dashboard_feed_item_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/sample_item_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/sample_user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DashboardRemoteDataSource {
  Future<List<DashboardFeedItemModel>> getHighlights() async {
    return const [
      DashboardFeedItemModel(
        title: 'BLoC & Cubit State Management',
        subtitle: 'Pure state stream with single-shot UI effect channels',
        icon: Icons.verified_rounded,
        iconColor: AppPalette.blue,
      ),
      DashboardFeedItemModel(
        title: 'RxDart & Transformers',
        subtitle: 'Debounce, Throttle, Droppable & Sequential streams',
        icon: Icons.flash_on_rounded,
        iconColor: AppPalette.warning,
      ),
      DashboardFeedItemModel(
        title: 'Result & Error Handling',
        subtitle:
            'Type-safe Result<T> sealed pattern with NetworkException mapping',
        icon: Icons.swap_horiz_rounded,
        iconColor: AppPalette.success,
      ),
    ];
  }

  Future<List<String>> fetchSampleFeatures() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      'Enterprise BLoC State Management',
      'GetIt & Injectable Dependency Injection',
      'AutoRoute Type-Safe Routing Engine',
      'Dio HTTP Client with Caching & Interceptors',
      'Google AdMob Ads & Consent Management',
      'Flutter Secure Storage & Local Database',
      'ANSI Multi-Level Colorful Logging Engine',
      'Clean Architecture without Domain Boilerplate',
    ];
  }

  Future<List<SampleUser>> fetchUsersPage({
    int page = 1,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return List.generate(pageSize, (index) {
      final id = (page - 1) * pageSize + index + 1;
      return SampleUser(
        id: 'usr_$id',
        name: 'Enterprise Developer #$id',
        email: 'developer$id@prakash.dev',
      );
    });
  }

  Future<SampleItemModel> submitForm({
    required String title,
    required String description,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return SampleItemModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      category: 'Submitted',
    );
  }
}
