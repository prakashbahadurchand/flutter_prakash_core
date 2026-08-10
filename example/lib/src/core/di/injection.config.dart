// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_data_source.dart' as _i970;
import '../../features/auth/data/repositories/auth_repository.dart' as _i573;
import '../../features/auth/presentation/bloc/login_cubit.dart' as _i281;
import '../../features/demo/data/datasources/demo_data_source.dart' as _i864;
import '../../features/demo/data/repositories/demo_repository.dart' as _i911;
import '../../features/demo/presentation/bloc/sample_fetch_cubit.dart' as _i360;
import '../../features/demo/presentation/bloc/sample_form_cubit.dart' as _i707;
import '../../features/demo/presentation/bloc/sample_paging_cubit.dart'
    as _i903;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i864.DemoDataSource>(() => _i864.DemoDataSource());
    gh.lazySingleton<_i970.AuthDataSource>(() => _i970.AuthDataSource());
    gh.lazySingleton<_i911.DemoRepository>(
      () => _i911.DemoRepository(gh<_i864.DemoDataSource>()),
    );
    gh.lazySingleton<_i573.AuthRepository>(
      () => _i573.AuthRepository(gh<_i970.AuthDataSource>()),
    );
    gh.factory<_i707.SampleFormCubit>(
      () => _i707.SampleFormCubit(gh<_i911.DemoRepository>()),
    );
    gh.factory<_i360.SampleFetchCubit>(
      () => _i360.SampleFetchCubit(gh<_i911.DemoRepository>()),
    );
    gh.factory<_i903.SamplePagingCubit>(
      () => _i903.SamplePagingCubit(gh<_i911.DemoRepository>()),
    );
    gh.factory<_i281.LoginCubit>(
      () => _i281.LoginCubit(gh<_i573.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
