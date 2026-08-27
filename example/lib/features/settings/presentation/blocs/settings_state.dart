import 'package:flutter_prakash_core_example/features/settings/data/models/user_preferences_model.dart';

class SettingsState {
  final UserPreferencesModel preferences;

  const SettingsState({required this.preferences});

  SettingsState copyWith({UserPreferencesModel? preferences}) {
    return SettingsState(preferences: preferences ?? this.preferences);
  }
}
