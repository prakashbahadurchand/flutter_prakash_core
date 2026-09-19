import 'package:flutter/material.dart';

/// Screen Size Breakpoints for Enterprise Applications
class ResponsiveBreakpoints {
  static const double watch = 300;
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

/// Device Types based on screen dimensions
enum DeviceType { watch, mobile, tablet, desktop, largeDesktop }

/// Responsive utility class containing context-agnostic checks & breakpoints
class Responsive {
  /// Check if the screen width falls into mobile category (< 600)
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < ResponsiveBreakpoints.mobile;

  /// Check if the screen width falls into tablet category (600 - 1199)
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= ResponsiveBreakpoints.mobile &&
      MediaQuery.sizeOf(context).width < ResponsiveBreakpoints.desktop;

  /// Check if the screen width falls into desktop category (>= 1200)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= ResponsiveBreakpoints.desktop;

  /// Check if the screen width is large desktop / ultra-wide (>= 1600)
  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= ResponsiveBreakpoints.largeDesktop;

  /// Get precise DeviceType based on constraints/width
  static DeviceType getDeviceType(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < ResponsiveBreakpoints.watch) return DeviceType.watch;
    if (width < ResponsiveBreakpoints.mobile) return DeviceType.mobile;
    if (width < ResponsiveBreakpoints.desktop) return DeviceType.tablet;
    if (width < ResponsiveBreakpoints.largeDesktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Get recommended grid column count based on current screen width
  static int getGridColumnCount(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < ResponsiveBreakpoints.mobile) return 1;
    if (width < ResponsiveBreakpoints.tablet) return 2;
    if (width < ResponsiveBreakpoints.desktop) return 3;
    if (width < ResponsiveBreakpoints.largeDesktop) return 4;
    return 6; // Ultra-wide / Large Desktop
  }

  /// Get standard page horizontal padding depending on screen size
  static double getPagePadding(BuildContext context) {
    if (isMobile(context)) return 12;
    if (isTablet(context)) return 20;
    return 32;
  }

  /// Get standard sidebar drawer/rail width
  static double getSidebarWidth(BuildContext context) {
    if (isDesktop(context)) return 260; // Expanded drawer / rail
    if (isTablet(context)) return 72; // Icon-only navigation rail
    return 0; // Bottom nav or hidden drawer on mobile
  }
}

/// Extension on BuildContext for quick inline responsive properties
extension ResponsiveContextX on BuildContext {
  // Screen dimensions
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  Orientation get orientation => MediaQuery.orientationOf(this);

  // Boolean state checks
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  bool get isLargeDesktop => Responsive.isLargeDesktop(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  // Enums and Layout metrics
  DeviceType get deviceType => Responsive.getDeviceType(this);
  int get autoGridColumns => Responsive.getGridColumnCount(this);
  double get pagePadding => Responsive.getPagePadding(this);
  double get sidebarWidth => Responsive.getSidebarWidth(this);

  /// Helper to return responsive values dynamically inline:
  /// e.g. `context.responsiveValue(mobile: 10, tablet: 20, desktop: 30)`
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

/// Conditional Widget Builder for custom layouts across breakpoints
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;
  final Widget Function(BuildContext context)? largeDesktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ResponsiveBreakpoints.largeDesktop &&
            largeDesktop != null) {
          return largeDesktop!(context);
        }
        if (constraints.maxWidth >= ResponsiveBreakpoints.desktop &&
            desktop != null) {
          return desktop!(context);
        }
        if (constraints.maxWidth >= ResponsiveBreakpoints.mobile &&
            tablet != null) {
          return tablet!(context);
        }
        return mobile(context);
      },
    );
  }
}

/// A auto-adapting GridView wrapper ideal for Admin Dashboard KPI/Metric cards
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final int? overrideColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.childAspectRatio = 1.4,
    this.overrideColumns,
  });

  @override
  Widget build(BuildContext context) {
    final int columns = overrideColumns ?? context.autoGridColumns;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => children[index],
    );
  }
}
