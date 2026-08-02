import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:get_it/get_it.dart';

import 'features/device/application/device_info_cubit.dart';
import 'features/device/data/repositories/device_info_repository_impl.dart';
import 'features/device/domain/repositories/device_info_repository.dart';
import 'features/device/domain/usecases/get_device_info.dart';
import 'features/device/domain/usecases/request_location_permission.dart';
import 'features/posts/application/posts_cubit.dart';
import 'features/posts/data/datasources/post_remote_data_source.dart';
import 'features/posts/data/repositories/post_repository_impl.dart';
import 'features/posts/domain/repositories/post_repository.dart';
import 'features/posts/domain/usecases/fetch_top_posts.dart';

/// Composition root wiring the whole Clean Architecture graph for the demo.
///
/// The plug-in's `PrakashEngine.initialize` already registers the low-level
/// engines (DioClient, PrakashNativeBridge, AppLogger, services). Here we
/// register only the feature-level domain/data/application objects.
final getIt = GetIt.instance;

void configureDependencies(GetIt container) {
  // --- Data layer ----------------------------------------------
  container.registerLazySingleton<LocationService>(() => LocationService());

container.registerLazySingleton<DeviceInfoRepository>(
  () => DeviceInfoRepositoryImpl(
    container<PrakashNativeBridge>(),
    container<LocationService>(),
  ),
);

  container.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSource(container<DioClient>()),
  );
  container.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(container<PostRemoteDataSource>()),
  );

  // --- Domain (usecases) ---------------------------------------
  container.registerLazySingleton<GetDeviceInfo>(
    () => GetDeviceInfo(container<DeviceInfoRepository>()),
  );
  container.registerLazySingleton<RequestLocationPermission>(
    () => RequestLocationPermission(container<DeviceInfoRepository>()),
  );
  container.registerLazySingleton<FetchTopPosts>(
    () => FetchTopPosts(container<PostRepository>()),
  );

  // --- Application (cubits) ------------------------------------
  container.registerFactory<DeviceInfoCubit>(
    () => DeviceInfoCubit(
      container<GetDeviceInfo>(),
      container<RequestLocationPermission>(),
    ),
  );
  container.registerFactory<PostsCubit>(
    () => PostsCubit(container<FetchTopPosts>()),
  );
}