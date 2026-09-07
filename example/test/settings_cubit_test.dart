import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core/fp_core.dart' hide test;
import 'package:flutter_prakash_core_example/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:flutter_prakash_core_example/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SettingsLocalDataSource localDataSource;
  late SettingsRepository repository;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    localDataSource = SettingsLocalDataSource(prefs);
    repository = SettingsRepository(localDataSource);
  });

  group('SettingsCubit', () {
    test('initial state loads preferences', () {
      final cubit = SettingsCubit(repository);
      expect(cubit.state.preferences.biometricsEnabled, isFalse);
      expect(cubit.state.preferences.notificationsEnabled, isTrue);
      cubit.close();
    });

    test('toggles preferences correctly', () async {
      final cubit = SettingsCubit(repository);
      await cubit.toggleBiometrics(true);
      expect(cubit.state.preferences.biometricsEnabled, isTrue);

      await cubit.toggleNotifications(false);
      expect(cubit.state.preferences.notificationsEnabled, isFalse);

      cubit.close();
    });
  });

  group('ThemeCubit', () {
    test('default theme is system', () {
      final cubit = ThemeCubit(prefs);
      expect(cubit.state, ThemeMode.system);
      cubit.close();
    });

    test('updates theme mode directly', () async {
      final cubit = ThemeCubit(prefs);
      await cubit.setThemeMode(ThemeMode.dark);
      expect(cubit.state, ThemeMode.dark);

      await cubit.setThemeMode(ThemeMode.light);
      expect(cubit.state, ThemeMode.light);
      cubit.close();
    });

    test('toggles theme properly', () async {
      final cubit = ThemeCubit(prefs);
      await cubit.setThemeMode(ThemeMode.light);
      await cubit.toggleTheme();
      expect(cubit.state, ThemeMode.dark);

      await cubit.toggleTheme();
      expect(cubit.state, ThemeMode.light);
      cubit.close();
    });
  });
}
