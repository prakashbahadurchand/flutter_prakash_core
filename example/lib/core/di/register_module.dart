import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../envs/envs.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio(AppEnv env) => Dio(
    BaseOptions(
      baseUrl: env.apiBaseUrl,
      connectTimeout: Duration(seconds: env.apiTimeoutSeconds),
      receiveTimeout: Duration(seconds: env.apiTimeoutSeconds),
      headers: {'Accept': 'application/json'},
    ),
  );
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @lazySingleton
  ThemeCubit themeCubit(SharedPreferences prefs) => ThemeCubit(prefs);

  @lazySingleton
  LocaleCubit localeCubit(SharedPreferences prefs) => LocaleCubit(
    prefs,
    defaultLocale: const Locale('en', 'US'),
    supportedLocales: const [
      Locale('en', 'US'), // English
      Locale('hi', 'IN'), // India
      Locale('ne', 'NP'), // Nepali
    ],
  );
}
