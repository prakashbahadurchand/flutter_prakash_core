// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_prakash/flutter_prakash.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/datasources/auth_data_source.dart' as _i970;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/presentation/blocs/login_cubit.dart' as _i396;
import '../../features/dashboard/presentation/blocs/dashboard_cubit.dart'
    as _i726;
import '../../features/demo/data/datasources/demo_data_source.dart' as _i864;
import '../../features/demo/data/repositories/demo_repository.dart' as _i911;
import '../../features/demo/presentation/blocs/sample_fetch_cubit.dart' as _i43;
import '../../features/demo/presentation/blocs/sample_form_cubit.dart' as _i90;
import '../../features/demo/presentation/blocs/sample_paging_cubit.dart'
    as _i668;
import '../envs/app_env.dart' as _i214;
import '../envs/env_dev.dart' as _i954;
import '../envs/env_prod.dart' as _i580;
import '../envs/envs.dart' as _i217;
import 'register_module.dart' as _i291;

const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i726.DashboardCubit>(() => _i726.DashboardCubit());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i864.DemoDataSource>(() => _i864.DemoDataSource());
    gh.lazySingleton<_i970.AuthDataSource>(() => _i970.AuthDataSource());
    gh.lazySingleton<_i361.ThemeCubit>(
      () => registerModule.themeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i361.LocaleCubit>(
      () => registerModule.localeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i911.DemoRepository>(
      () => _i911.DemoRepository(gh<_i864.DemoDataSource>()),
    );
    gh.lazySingleton<_i214.AppEnv>(() => _i954.DevEnv(), registerFor: {_dev});
    gh.lazySingleton<_i214.AppEnv>(() => _i580.ProdEnv(), registerFor: {_prod});
    gh.lazySingleton<_i573.AuthRepository>(
      () => _i573.AuthRepository(gh<_i970.AuthDataSource>()),
    );
    gh.factory<_i90.SampleFormCubit>(
      () => _i90.SampleFormCubit(gh<_i911.DemoRepository>()),
    );
    gh.factory<_i43.SampleFetchCubit>(
      () => _i43.SampleFetchCubit(gh<_i911.DemoRepository>()),
    );
    gh.factory<_i668.SamplePagingCubit>(
      () => _i668.SamplePagingCubit(gh<_i911.DemoRepository>()),
    );
    gh.factory<_i396.LoginCubit>(
      () => _i396.LoginCubit(gh<_i573.AuthRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio(gh<_i217.AppEnv>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
