import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum DashboardTab {
  home('Home', Icons.auto_stories_rounded),
  blocDemo('BLoC Engine', Icons.favorite_rounded),
  coreUtils('Core & Network', Icons.mark_email_read_rounded),
  settings('Settings', Icons.tune_rounded);

  final String title;
  final IconData icon;

  const DashboardTab(this.title, this.icon);
}

class DashboardState extends Equatable {
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

  DashboardTab get currentTab =>
      DashboardTab.values.elementAtOrNull(tabIndex) ?? DashboardTab.home;

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

  @override
  List<Object?> get props => [
        tabIndex,
        notificationsEnabled,
        crashlyticsEnabled,
        analyticsEnabled,
        biometricsEnabled,
      ];
}
