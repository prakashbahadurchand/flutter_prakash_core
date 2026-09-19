import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Screen breakpoint categories for responsive admin panel layouts.
enum AdminBreakpointType {
  /// Screen width < 600px
  mobile,

  /// Screen width between 600px and 1024px
  tablet,

  /// Screen width between 1024px and 1440px
  desktop,

  /// Screen width > 1440px
  ultraWide,
}

/// Trend trajectory direction for KPI metric cards.
enum TrendDirection {
  /// Upward positive or growth trajectory
  up,

  /// Downward or declining trajectory
  down,

  /// Flat or unchanged trajectory
  neutral,
}

/// Visual presentation variant for metric cards.
enum MetricCardVariant {
  /// Standard elevated/bordered card
  standard,

  /// Compact card with condensed padding
  compact,

  /// Outlined border without surface tint
  outlined,

  /// Filled background with accent or secondary container color
  filled,
}

/// Callback signature when an admin navigation item is selected.
typedef AdminNavDestinationCallback =
    void Function(AdminNavItem item, int index);

/// Role-based access predicate to evaluate permission.
typedef AdminUserRolePredicate = bool Function(List<String>? requiredRoles);

/// Enterprise navigation item schema supporting deep nesting, badges, and RBAC.
class AdminNavItem {
  /// Unique identifier for the item (falls back to [label] if not specified).
  final String id;

  /// Display text label.
  final String label;

  /// Icon shown when the destination is unselected.
  final IconData icon;

  /// Icon shown when the destination is selected.
  final IconData? selectedIcon;

  /// Optional badge text (e.g. '12', 'New', 'Live').
  final String? badgeText;

  /// Optional badge background color.
  final Color? badgeColor;

  /// Target route info for declarative navigation (e.g. AutoRoute [PageRouteInfo]).
  final PageRouteInfo? route;

  /// Role-based access control whitelist. If null or empty, item is accessible to all.
  final List<String>? roles;

  /// Nested sub-navigation destinations for collapsible navigation trees.
  final List<AdminNavItem> children;

  /// Custom tap callback. If null, defaults to route navigation or expansion toggle.
  final VoidCallback? onTap;

  /// Whether this item represents a visual divider in the sidebar menu.
  final bool isDivider;

  /// Whether this item represents a section group header rather than a clickable link.
  final bool isHeader;

  /// Constructs a scalable navigation destination.
  const AdminNavItem({
    String? id,
    required this.label,
    required this.icon,
    this.route,
    this.selectedIcon,
    this.badgeText,
    this.badgeColor,
    this.roles,
    this.children = const <AdminNavItem>[],
    this.onTap,
    this.isDivider = false,
    this.isHeader = false,
  }) : id = id ?? label;

  /// Creates a visual divider item.
  const AdminNavItem.divider()
    : id = 'divider',
      label = '',
      icon = Icons.horizontal_rule,
      route = null,
      selectedIcon = null,
      badgeText = null,
      badgeColor = null,
      roles = null,
      children = const <AdminNavItem>[],
      onTap = null,
      isDivider = true,
      isHeader = false;

  /// Creates a section group header item.
  const AdminNavItem.header({required this.label, this.roles})
    : id = label,
      icon = Icons.label_outline,
      route = null,
      selectedIcon = null,
      badgeText = null,
      badgeColor = null,
      children = const <AdminNavItem>[],
      onTap = null,
      isDivider = false,
      isHeader = true;

  /// Whether this navigation item has nested child destinations.
  bool get hasChildren => children.isNotEmpty;

  /// Checks if this item is permitted given the current user's assigned roles.
  bool isVisibleForRoles(List<String>? userRoles) {
    if (roles == null || roles!.isEmpty) return true;
    if (userRoles == null || userRoles.isEmpty) return false;
    return roles!.any((role) => userRoles.contains(role));
  }

  /// Copies this navigation item with optional updated fields.
  AdminNavItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    IconData? selectedIcon,
    String? badgeText,
    Color? badgeColor,
    PageRouteInfo? route,
    List<String>? roles,
    List<AdminNavItem>? children,
    VoidCallback? onTap,
    bool? isDivider,
    bool? isHeader,
  }) {
    return AdminNavItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      badgeText: badgeText ?? this.badgeText,
      badgeColor: badgeColor ?? this.badgeColor,
      route: route ?? this.route,
      roles: roles ?? this.roles,
      children: children ?? this.children,
      onTap: onTap ?? this.onTap,
      isDivider: isDivider ?? this.isDivider,
      isHeader: isHeader ?? this.isHeader,
    );
  }
}

/// Breadcrumb trail step item for page-level navigation.
class AdminBreadcrumbItem {
  /// Breadcrumb step label text.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Tap callback invoked when the breadcrumb segment is pressed.
  final VoidCallback? onTap;

  /// Target route if navigation is handled via AutoRoute.
  final PageRouteInfo? route;

  const AdminBreadcrumbItem({
    required this.label,
    this.icon,
    this.onTap,
    this.route,
  });
}
