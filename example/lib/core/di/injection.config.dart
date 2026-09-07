// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_prakash_ads/flutter_prakash_ads.dart' as _i499;
import 'package:flutter_prakash_core/fp_core.dart' as _i1069;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../config/config.dart' as _i658;
import '../../config/envs/app_env.dart' as _i952;
import '../../config/envs/env_dev.dart' as _i576;
import '../../config/envs/env_prod.dart' as _i560;
import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository.dart' as _i574;
import '../../features/auth/presentation/blocs/auth_cubit.dart' as _i67;
import '../../features/auth/presentation/blocs/change_password/change_password_cubit.dart'
    as _i65;
import '../../features/auth/presentation/blocs/email_verification/email_verification_cubit.dart'
    as _i301;
import '../../features/auth/presentation/blocs/forgot_password/forgot_password_cubit.dart'
    as _i257;
import '../../features/auth/presentation/blocs/login/login_cubit.dart' as _i389;
import '../../features/auth/presentation/blocs/register/register_cubit.dart'
    as _i459;
import '../../features/auth/presentation/blocs/reset_password/reset_password_cubit.dart'
    as _i700;
import '../../features/common/data/datasources/common_local_data_source.dart'
    as _i137;
import '../../features/common/data/repositories/common_repository.dart'
    as _i169;
import '../../features/common/presentation/blocs/feedback_cubit.dart' as _i521;
import '../../features/common/presentation/blocs/legal_cubit.dart' as _i627;
import '../../features/dashboard/data/datasources/dashboard_local_data_source.dart'
    as _i838;
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart'
    as _i258;
import '../../features/dashboard/data/repositories/dashboard_repository.dart'
    as _i75;
import '../../features/dashboard/presentation/blocs/dashboard_cubit.dart'
    as _i726;
import '../../features/dashboard/presentation/blocs/sample_fetch_cubit.dart'
    as _i402;
import '../../features/dashboard/presentation/blocs/sample_form_cubit.dart'
    as _i702;
import '../../features/dashboard/presentation/blocs/sample_paging_cubit.dart'
    as _i403;
import '../../features/dashboard/presentation/blocs/sample_search_bloc.dart'
    as _i617;
import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart'
    as _i870;
import '../../features/onboarding/data/repositories/onboarding_repository.dart'
    as _i284;
import '../../features/onboarding/presentation/blocs/onboarding_cubit.dart'
    as _i610;
import '../../features/settings/data/datasources/settings_local_data_source.dart'
    as _i599;
import '../../features/settings/data/repositories/settings_repository.dart'
    as _i450;
import '../../features/settings/presentation/blocs/settings_cubit.dart'
    as _i573;
import '../../features/splash/data/datasources/splash_local_data_source.dart'
    as _i240;
import '../../features/splash/data/repositories/splash_repository.dart'
    as _i120;
import '../../features/splash/presentation/blocs/splash_cubit.dart' as _i856;
import '../ads/cubit/ads_cubit.dart' as _i168;
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
    gh.factory<_i617.SampleSearchBloc>(() => _i617.SampleSearchBloc());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => registerModule.provideInternetConnection(),
    );
    gh.lazySingleton<_i499.NetworkInfo>(
      () => registerModule.provideNetworkInfo(),
    );
    gh.lazySingleton<_i499.AdsService>(
      () => registerModule.provideAdsService(),
    );
    gh.lazySingleton<_i499.AppOpenAdManager>(
      () => registerModule.provideAppOpenAdManager(),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => const _i107.AuthRemoteDataSource(),
    );
    gh.lazySingleton<_i137.CommonLocalDataSource>(
      () => const _i137.CommonLocalDataSource(),
    );
    gh.lazySingleton<_i838.DashboardLocalDataSource>(
      () => const _i838.DashboardLocalDataSource(),
    );
    gh.lazySingleton<_i258.DashboardRemoteDataSource>(
      () => _i258.DashboardRemoteDataSource(),
    );
    gh.lazySingleton<_i952.AppEnv>(() => _i576.DevEnv(), registerFor: {_dev});
    gh.lazySingleton<_i952.AppEnv>(() => _i560.ProdEnv(), registerFor: {_prod});
    gh.lazySingleton<_i852.AuthLocalDataSource>(
      () => _i852.AuthLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i870.OnboardingLocalDataSource>(
      () => _i870.OnboardingLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i599.SettingsLocalDataSource>(
      () => _i599.SettingsLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i240.SplashLocalDataSource>(
      () => _i240.SplashLocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i168.AdsCubit>(
      () => _i168.AdsCubit(adsService: gh<_i499.AdsService>()),
    );
    gh.lazySingleton<_i450.SettingsRepository>(
      () => _i450.SettingsRepository(gh<_i599.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i169.CommonRepository>(
      () => _i169.CommonRepository(gh<_i137.CommonLocalDataSource>()),
    );
    gh.lazySingleton<_i75.DashboardRepository>(
      () => _i75.DashboardRepository(
        gh<_i838.DashboardLocalDataSource>(),
        gh<_i258.DashboardRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1069.ThemeCubit>(
      () => registerModule.themeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1069.LocaleCubit>(
      () => registerModule.localeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i573.SettingsCubit>(
      () => _i573.SettingsCubit(gh<_i450.SettingsRepository>())..init(),
    );
    gh.lazySingleton<_i574.AuthRepository>(
      () => _i574.AuthRepository(
        gh<_i852.AuthLocalDataSource>(),
        gh<_i107.AuthRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i284.OnboardingRepository>(
      () => _i284.OnboardingRepository(gh<_i870.OnboardingLocalDataSource>()),
    );
    gh.factory<_i402.SampleFetchCubit>(
      () => _i402.SampleFetchCubit(gh<_i75.DashboardRepository>())..init(),
    );
    gh.factory<_i702.SampleFormCubit>(
      () => _i702.SampleFormCubit(gh<_i75.DashboardRepository>()),
    );
    gh.factory<_i403.SamplePagingCubit>(
      () => _i403.SamplePagingCubit(gh<_i75.DashboardRepository>()),
    );
    gh.factory<_i726.DashboardCubit>(
      () => _i726.DashboardCubit(
        gh<_i75.DashboardRepository>(),
        gh<_i450.SettingsRepository>(),
      )..init(),
    );
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio(gh<_i658.AppEnv>()));
    gh.lazySingleton<_i120.SplashRepository>(
      () => _i120.SplashRepository(gh<_i240.SplashLocalDataSource>()),
    );
    gh.lazySingleton<_i67.AuthCubit>(
      () => _i67.AuthCubit(gh<_i574.AuthRepository>())..init(),
    );
    gh.factory<_i856.SplashCubit>(
      () => _i856.SplashCubit(gh<_i120.SplashRepository>()),
    );
    gh.factory<_i521.FeedbackCubit>(
      () => _i521.FeedbackCubit(gh<_i169.CommonRepository>()),
    );
    gh.factory<_i627.LegalCubit>(
      () => _i627.LegalCubit(gh<_i169.CommonRepository>()),
    );
    gh.factory<_i610.OnboardingCubit>(
      () => _i610.OnboardingCubit(gh<_i284.OnboardingRepository>())..init(),
    );
    gh.factory<_i65.ChangePasswordCubit>(
      () => _i65.ChangePasswordCubit(gh<_i574.AuthRepository>()),
    );
    gh.factory<_i301.EmailVerificationCubit>(
      () => _i301.EmailVerificationCubit(gh<_i574.AuthRepository>()),
    );
    gh.factory<_i257.ForgotPasswordCubit>(
      () => _i257.ForgotPasswordCubit(gh<_i574.AuthRepository>()),
    );
    gh.factory<_i389.LoginCubit>(
      () => _i389.LoginCubit(gh<_i574.AuthRepository>()),
    );
    gh.factory<_i459.RegisterCubit>(
      () => _i459.RegisterCubit(gh<_i574.AuthRepository>()),
    );
    gh.factory<_i700.ResetPasswordCubit>(
      () => _i700.ResetPasswordCubit(gh<_i574.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
