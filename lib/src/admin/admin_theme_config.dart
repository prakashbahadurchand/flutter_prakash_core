import 'package:flutter/material.dart';

/// Configuration object defining styling, dimensional constraints, and animation
/// physics for the enterprise Admin Dashboard suite.
class AdminThemeConfig {
  /// Width of the side navigation rail/sidebar when fully expanded.
  final double sidebarExpandedWidth;

  /// Width of the side navigation rail when collapsed into icon-only mode.
  final double sidebarCollapsedWidth;

  /// Height of the persistent top header bar on desktop and tablet devices.
  final double headerHeight;

  /// Height of the mobile app bar.
  final double mobileAppBarHeight;

  /// Duration of sidebar expand/collapse and transition animations.
  final Duration animationDuration;

  /// Animation curve used for sidebar expand/collapse transitions.
  final Curve animationCurve;

  /// Screen width threshold under which the layout switches to mobile mode (< 600px).
  final double mobileBreakpoint;

  /// Screen width threshold for tablet mode (600px - 1024px).
  final double tabletBreakpoint;

  /// Screen width threshold for desktop mode (1024px - 1440px). Above this is ultra-wide (> 1440px).
  final double desktopBreakpoint;

  /// Background color of the navigation sidebar. Defaults to [ColorScheme.surface].
  final Color? sidebarBackgroundColor;

  /// Background color of the top header bar. Defaults to [ColorScheme.surface].
  final Color? headerBackgroundColor;

  /// Background color of the main body content area. Defaults to [ColorScheme.surface].
  final Color? contentBackgroundColor;

  /// Indicator color for the active navigation item. Defaults to [ColorScheme.primaryContainer].
  final Color? indicatorColor;

  /// Foreground color for the selected navigation item icon and label.
  final Color? selectedItemColor;

  /// Foreground color for unselected navigation item icon and label.
  final Color? unselectedItemColor;

  /// Divider and border line color. Defaults to [ThemeData.dividerColor] with opacity.
  final Color? dividerColor;

  /// Elevation applied to the top header bar. Defaults to 0.0.
  final double headerElevation;

  /// Elevation applied to the sidebar panel. Defaults to 0.0.
  final double sidebarElevation;

  /// Border radius applied to individual navigation destination tiles.
  final BorderRadius itemBorderRadius;

  /// Padding applied around navigation destination tiles.
  final EdgeInsetsGeometry itemPadding;

  /// Whether destination tiles should use compact/dense vertical metrics.
  final bool dense;

  /// Whether sidebar expand/collapse state should persist across rebuilds.
  final bool enableRailPersistence;

  /// Standard production-ready defaults for enterprise admin panels.
  const AdminThemeConfig.defaultConfig({
    this.sidebarExpandedWidth = 260.0,
    this.sidebarCollapsedWidth = 72.0,
    this.headerHeight = 64.0,
    this.mobileAppBarHeight = kToolbarHeight,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.fastOutSlowIn,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 1024.0,
    this.desktopBreakpoint = 1440.0,
    this.sidebarBackgroundColor,
    this.headerBackgroundColor,
    this.contentBackgroundColor,
    this.indicatorColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.dividerColor,
    this.headerElevation = 0.0,
    this.sidebarElevation = 0.0,
    this.itemBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.dense = false,
    this.enableRailPersistence = true,
  });

  /// Custom constructor with full field configuration.
  const AdminThemeConfig({
    this.sidebarExpandedWidth = 260.0,
    this.sidebarCollapsedWidth = 72.0,
    this.headerHeight = 64.0,
    this.mobileAppBarHeight = kToolbarHeight,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.fastOutSlowIn,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 1024.0,
    this.desktopBreakpoint = 1440.0,
    this.sidebarBackgroundColor,
    this.headerBackgroundColor,
    this.contentBackgroundColor,
    this.indicatorColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.dividerColor,
    this.headerElevation = 0.0,
    this.sidebarElevation = 0.0,
    this.itemBorderRadius = const BorderRadius.all(Radius.circular(8)),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.dense = false,
    this.enableRailPersistence = true,
  });

  /// Creates a copy of this configuration with the given fields replaced.
  AdminThemeConfig copyWith({
    double? sidebarExpandedWidth,
    double? sidebarCollapsedWidth,
    double? headerHeight,
    double? mobileAppBarHeight,
    Duration? animationDuration,
    Curve? animationCurve,
    double? mobileBreakpoint,
    double? tabletBreakpoint,
    double? desktopBreakpoint,
    Color? sidebarBackgroundColor,
    Color? headerBackgroundColor,
    Color? contentBackgroundColor,
    Color? indicatorColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? dividerColor,
    double? headerElevation,
    double? sidebarElevation,
    BorderRadius? itemBorderRadius,
    EdgeInsetsGeometry? itemPadding,
    bool? dense,
    bool? enableRailPersistence,
  }) {
    return AdminThemeConfig(
      sidebarExpandedWidth: sidebarExpandedWidth ?? this.sidebarExpandedWidth,
      sidebarCollapsedWidth:
          sidebarCollapsedWidth ?? this.sidebarCollapsedWidth,
      headerHeight: headerHeight ?? this.headerHeight,
      mobileAppBarHeight: mobileAppBarHeight ?? this.mobileAppBarHeight,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      tabletBreakpoint: tabletBreakpoint ?? this.tabletBreakpoint,
      desktopBreakpoint: desktopBreakpoint ?? this.desktopBreakpoint,
      sidebarBackgroundColor:
          sidebarBackgroundColor ?? this.sidebarBackgroundColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      contentBackgroundColor:
          contentBackgroundColor ?? this.contentBackgroundColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      dividerColor: dividerColor ?? this.dividerColor,
      headerElevation: headerElevation ?? this.headerElevation,
      sidebarElevation: sidebarElevation ?? this.sidebarElevation,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
      itemPadding: itemPadding ?? this.itemPadding,
      dense: dense ?? this.dense,
      enableRailPersistence:
          enableRailPersistence ?? this.enableRailPersistence,
    );
  }
}

/// InheritedWidget providing [AdminThemeConfig] down the widget subtree.
class AdminTheme extends InheritedWidget {
  /// The admin configuration instance.
  final AdminThemeConfig config;

  const AdminTheme({super.key, required this.config, required super.child});

  /// Retrieves the nearest [AdminThemeConfig], falling back to [AdminThemeConfig.defaultConfig].
  static AdminThemeConfig of(BuildContext context) {
    final AdminTheme? inherited = context
        .dependOnInheritedWidgetOfExactType<AdminTheme>();
    return inherited?.config ?? const AdminThemeConfig.defaultConfig();
  }

  /// Retrieves the nearest [AdminThemeConfig] if present in context.
  static AdminThemeConfig? maybeOf(BuildContext context) {
    final AdminTheme? inherited = context
        .dependOnInheritedWidgetOfExactType<AdminTheme>();
    return inherited?.config;
  }

  @override
  bool updateShouldNotify(AdminTheme oldWidget) => config != oldWidget.config;
}
