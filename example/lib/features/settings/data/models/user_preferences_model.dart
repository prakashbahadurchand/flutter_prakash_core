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
}
