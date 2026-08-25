import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

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
