class DashboardStatsModel {
  final String architecture;
  final String diContainer;
  final int activePluginsCount;
  final bool isEngineOnline;

  const DashboardStatsModel({
    required this.architecture,
    required this.diContainer,
    required this.activePluginsCount,
    required this.isEngineOnline,
  });
}
