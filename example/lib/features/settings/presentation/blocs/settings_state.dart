import 'package:flutter_prakash_core_example/features/settings/data/models/user_preferences_model.dart';

class SettingsState {
  final UserPreferencesModel preferences;
  final bool isSaving;

  const SettingsState({
    required this.preferences,
    this.isSaving = false,
  });

  SettingsState copyWith({
    UserPreferencesModel? preferences,
    bool? isSaving,
  }) {
    return SettingsState(
      preferences: preferences ?? this.preferences,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
