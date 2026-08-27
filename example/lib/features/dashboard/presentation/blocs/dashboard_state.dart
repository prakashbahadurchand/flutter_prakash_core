enum DashboardTab {
  overview(0, 'Dashboard'),
  blocs(1, 'BLoC Engine'),
  utilities(2, 'Core Utilities'),
  settings(3, 'Preferences');

  final int tabNumber;
  final String title;
  const DashboardTab(this.tabNumber, this.title);
}

class DashboardState {
  final int tabIndex;
  final bool notificationsEnabled;
  final bool crashlyticsEnabled;
  final bool analyticsEnabled;
  final bool biometricsEnabled;

  const DashboardState({
    this.tabIndex = 0,
    this.notificationsEnabled = true,
    this.crashlyticsEnabled = true,
    this.analyticsEnabled = true,
    this.biometricsEnabled = false,
  });

  DashboardTab get currentTab => DashboardTab.values.firstWhere(
    (t) => t.tabNumber == tabIndex,
    orElse: () => DashboardTab.overview,
  );

  DashboardState copyWith({
    int? tabIndex,
    bool? notificationsEnabled,
    bool? crashlyticsEnabled,
    bool? analyticsEnabled,
    bool? biometricsEnabled,
  }) {
    return DashboardState(
      tabIndex: tabIndex ?? this.tabIndex,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      crashlyticsEnabled: crashlyticsEnabled ?? this.crashlyticsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
    );
  }
}
