class UserPreferencesModel {
  final bool biometricsEnabled;
  final bool notificationsEnabled;
  final bool analyticsEnabled;
  final bool crashlyticsEnabled;

  const UserPreferencesModel({
    required this.biometricsEnabled,
    required this.notificationsEnabled,
    required this.analyticsEnabled,
    required this.crashlyticsEnabled,
  });

  UserPreferencesModel copyWith({
    bool? biometricsEnabled,
    bool? notificationsEnabled,
    bool? analyticsEnabled,
    bool? crashlyticsEnabled,
  }) {
    return UserPreferencesModel(
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashlyticsEnabled: crashlyticsEnabled ?? this.crashlyticsEnabled,
    );
  }
}
