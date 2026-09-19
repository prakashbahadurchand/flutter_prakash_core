import 'package:flutter/material.dart';
import 'admin_theme_config.dart';
import 'admin_types.dart';

/// Enterprise-grade, adaptive layout shell featuring collapsible sidebar rails,
/// persistent top-bar action menus, role-based visibility, and mobile drawer/navigation bar.
class AdminPanelScaffold extends StatefulWidget {
  /// Currently active destination index.
  final int selectedIndex;

  /// Callback triggered when a top-level destination is selected.
  final ValueChanged<int> onDestinationSelected;

  /// Full navigation destination hierarchy.
  final List<AdminNavItem> items;

  /// Primary page body content.
  final Widget body;

  /// Brand logo or application title rendered at the top of the sidebar and drawer.
  final Widget? brandHeader;

  /// User account profile tile rendered at the top-right of the header (Desktop/Tablet)
  /// or bottom of the slide-out drawer (Mobile).
  final Widget? userProfileHeader;

  /// Action buttons rendered in the persistent top header (e.g. notifications, search, theme toggle).
  final List<Widget>? headerActions;

  /// Custom header title or breadcrumb widget. Defaults to the selected item label.
  final Widget? pageTitle;

  /// Custom Mobile [AppBar] override.
  final PreferredSizeWidget? appBar;

  /// Custom Mobile bottom [NavigationBar] override.
  final Widget? bottomNavigationBar;

  /// Custom widget rendered at the bottom of the desktop navigation sidebar.
  final Widget? sidebarFooter;

  /// Active user roles for role-based navigation filtering.
  final List<String>? currentUserRoles;

  /// Custom theme configuration override. Falls back to [AdminTheme.of(context)].
  final AdminThemeConfig? themeConfig;

  /// Background color of the main body viewport.
  final Color? backgroundColor;

  /// Initial collapsed/expanded state of the desktop navigation rail.
  final bool initialRailExpanded;

  /// Callback notified whenever the navigation rail expands or collapses.
  final ValueChanged<bool>? onRailExpandedChanged;

  const AdminPanelScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
    required this.body,
    this.brandHeader,
    this.userProfileHeader,
    this.headerActions,
    this.pageTitle,
    this.appBar,
    this.bottomNavigationBar,
    this.sidebarFooter,
    this.currentUserRoles,
    this.themeConfig,
    this.backgroundColor,
    this.initialRailExpanded = true,
    this.onRailExpandedChanged,
  });

  @override
  State<AdminPanelScaffold> createState() => _AdminPanelScaffoldState();
}

class _AdminPanelScaffoldState extends State<AdminPanelScaffold> {
  late bool _isRailExpanded;

  @override
  void initState() {
    super.initState();
    _isRailExpanded = widget.initialRailExpanded;
  }

  void _toggleRail() {
    setState(() {
      _isRailExpanded = !_isRailExpanded;
    });
    widget.onRailExpandedChanged?.call(_isRailExpanded);
  }

  /// Filters items based on [AdminPanelScaffold.currentUserRoles].
  List<AdminNavItem> get _filteredItems {
    if (widget.currentUserRoles == null || widget.currentUserRoles!.isEmpty) {
      return widget.items;
    }
    return widget.items
        .where((item) => item.isVisibleForRoles(widget.currentUserRoles))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = widget.themeConfig ?? AdminTheme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    final bool isMobile = screenWidth < config.mobileBreakpoint;
    final bool isDesktop = screenWidth >= config.desktopBreakpoint;
    final items = _filteredItems;

    final effectiveContentBg =
        widget.backgroundColor ??
        config.contentBackgroundColor ??
        theme.colorScheme.surface;

    return Scaffold(
      appBar: isMobile
          ? (widget.appBar ?? _buildDefaultMobileAppBar(context, items, config))
          : null,
      drawer: isMobile
          ? _buildMobileDrawer(context, items, theme, config)
          : null,
      backgroundColor: effectiveContentBg,
      body: Row(
        children: [
          // Desktop / Tablet Navigation Sidebar
          if (!isMobile)
            _AdminSidebar(
              items: items,
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: widget.onDestinationSelected,
              isExpanded: isDesktop && _isRailExpanded,
              canToggleExpand: isDesktop,
              onToggleExpand: _toggleRail,
              brandHeader: widget.brandHeader,
              sidebarFooter: widget.sidebarFooter,
              config: config,
            ),
          if (!isMobile)
            VerticalDivider(
              thickness: 1,
              width: 1,
              color:
                  config.dividerColor ??
                  theme.dividerColor.withValues(alpha: 0.12),
            ),

          // Main Viewport Area
          Expanded(
            child: Column(
              children: [
                // Persistent Top Header Bar (Desktop/Tablet)
                if (!isMobile)
                  _AdminTopHeader(
                    title: widget.pageTitle,
                    defaultTitle:
                        items.isNotEmpty && widget.selectedIndex < items.length
                        ? items[widget.selectedIndex].label
                        : '',
                    headerActions: widget.headerActions,
                    userProfileHeader: widget.userProfileHeader,
                    config: config,
                  ),

                // Main Page Content Area
                Expanded(
                  child: SafeArea(
                    top: isMobile,
                    left: false,
                    right: false,
                    child: widget.body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Mobile Bottom Navigation Bar
      bottomNavigationBar: isMobile
          ? (widget.bottomNavigationBar ??
                _buildDefaultMobileBottomNav(context, items, theme))
          : null,
    );
  }

  PreferredSizeWidget _buildDefaultMobileAppBar(
    BuildContext context,
    List<AdminNavItem> items,
    AdminThemeConfig config,
  ) {
    final currentItem = items.isNotEmpty && widget.selectedIndex < items.length
        ? items[widget.selectedIndex]
        : null;

    return AppBar(
      title: widget.pageTitle ?? Text(currentItem?.label ?? ''),
      centerTitle: true,
      toolbarHeight: config.mobileAppBarHeight,
      actions: [
        if (widget.headerActions != null) ...widget.headerActions!,
        if (widget.userProfileHeader != null)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: widget.userProfileHeader,
          ),
      ],
    );
  }

  Widget? _buildDefaultMobileBottomNav(
    BuildContext context,
    List<AdminNavItem> items,
    ThemeData theme,
  ) {
    // Only show selectable items that have no header/divider flags
    final actionableItems = items
        .where((it) => !it.isDivider && !it.isHeader)
        .take(5)
        .toList();

    if (actionableItems.isEmpty) return null;

    // Resolve active index within actionable items
    final activeActionableIndex = widget.selectedIndex < actionableItems.length
        ? widget.selectedIndex
        : 0;

    return NavigationBar(
      selectedIndex: activeActionableIndex,
      onDestinationSelected: (idx) {
        final originalIdx = items.indexOf(actionableItems[idx]);
        if (originalIdx != -1) {
          widget.onDestinationSelected(originalIdx);
        }
      },
      destinations: actionableItems.map((item) {
        return NavigationDestination(
          icon: _buildIconWithBadge(item, false),
          selectedIcon: _buildIconWithBadge(item, true),
          label: item.label,
        );
      }).toList(),
    );
  }

  Widget _buildMobileDrawer(
    BuildContext context,
    List<AdminNavItem> items,
    ThemeData theme,
    AdminThemeConfig config,
  ) {
    return Drawer(
      backgroundColor:
          config.sidebarBackgroundColor ?? theme.colorScheme.surface,
      child: Column(
        children: [
          // Drawer Brand Header
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child:
                  widget.brandHeader ??
                  Text(
                    'Admin Console',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),
          ),

          // Drawer Navigation List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                if (item.isDivider) {
                  return Divider(
                    height: 16,
                    color:
                        config.dividerColor ??
                        theme.dividerColor.withValues(alpha: 0.12),
                  );
                }

                if (item.isHeader) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      item.label.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: 1.1,
                      ),
                    ),
                  );
                }

                final isSelected = index == widget.selectedIndex;

                if (item.hasChildren) {
                  return ExpansionTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                    title: Text(item.label),
                    initiallyExpanded: isSelected,
                    children: item.children.map((childItem) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(
                          left: 48,
                          right: 16,
                        ),
                        leading: Icon(childItem.icon, size: 20),
                        title: Text(childItem.label),
                        trailing: childItem.badgeText != null
                            ? _buildBadgePill(childItem)
                            : null,
                        onTap: () {
                          Navigator.pop(context);
                          childItem.onTap?.call();
                        },
                      );
                    }).toList(),
                  );
                }

                return ListTile(
                  leading: Icon(
                    isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
                    color: isSelected ? theme.colorScheme.primary : null,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: item.badgeText != null
                      ? _buildBadgePill(item)
                      : null,
                  selected: isSelected,
                  selectedTileColor: theme.colorScheme.primaryContainer
                      .withValues(alpha: 0.3),
                  onTap: () {
                    Navigator.pop(context);
                    if (item.onTap != null) {
                      item.onTap!();
                    } else {
                      widget.onDestinationSelected(index);
                    }
                  },
                );
              },
            ),
          ),

          // User Profile Footer in Mobile Drawer
          if (widget.userProfileHeader != null) ...[
            Divider(
              height: 1,
              color:
                  config.dividerColor ??
                  theme.dividerColor.withValues(alpha: 0.12),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: widget.userProfileHeader,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconWithBadge(AdminNavItem item, bool isSelected) {
    final iconData = isSelected ? (item.selectedIcon ?? item.icon) : item.icon;
    if (item.badgeText == null) return Icon(iconData);
    return Badge(
      label: Text(item.badgeText!),
      backgroundColor: item.badgeColor,
      child: Icon(iconData),
    );
  }

  Widget _buildBadgePill(AdminNavItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: item.badgeColor ?? Colors.red.shade600,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Text(
        item.badgeText!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Dedicated stateful top header bar widget to isolate repaint boundaries and SafeAreas.
class _AdminTopHeader extends StatelessWidget {
  final Widget? title;
  final String defaultTitle;
  final List<Widget>? headerActions;
  final Widget? userProfileHeader;
  final AdminThemeConfig config;

  const _AdminTopHeader({
    required this.title,
    required this.defaultTitle,
    required this.headerActions,
    required this.userProfileHeader,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = config.headerBackgroundColor ?? theme.colorScheme.surface;

    return SafeArea(
      bottom: false,
      child: Material(
        elevation: config.headerElevation,
        color: bg,
        child: Container(
          height: config.headerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    config.dividerColor ??
                    theme.dividerColor.withValues(alpha: 0.12),
              ),
            ),
          ),
          child: Row(
            children: [
              // Page Title / Section Breadcrumb slot
              Expanded(
                child:
                    title ??
                    Text(
                      defaultTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),

              // Header actions slot (Search, Notifications, Theme toggle)
              if (headerActions != null) ...[
                ...headerActions!,
                const SizedBox(width: 12),
              ],

              // Profile slot
              ?userProfileHeader,
            ],
          ),
        ),
      ),
    );
  }
}

/// Dedicated sidebar component managing animated expand/collapse transitions,
/// nested destinations, badges, and user footer slots.
class _AdminSidebar extends StatelessWidget {
  final List<AdminNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isExpanded;
  final bool canToggleExpand;
  final VoidCallback onToggleExpand;
  final Widget? brandHeader;
  final Widget? sidebarFooter;
  final AdminThemeConfig config;

  const _AdminSidebar({
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.isExpanded,
    required this.canToggleExpand,
    required this.onToggleExpand,
    required this.brandHeader,
    required this.sidebarFooter,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sidebarBg =
        config.sidebarBackgroundColor ?? theme.colorScheme.surface;

    return AnimatedContainer(
      duration: config.animationDuration,
      curve: config.animationCurve,
      width: isExpanded
          ? config.sidebarExpandedWidth
          : config.sidebarCollapsedWidth,
      child: Material(
        elevation: config.sidebarElevation,
        color: sidebarBg,
        child: SafeArea(
          right: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sidebar Header Slot (Brand + Expand/Collapse Button)
              SizedBox(
                height: config.headerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      if (isExpanded && brandHeader != null)
                        Expanded(child: brandHeader!)
                      else if (!isExpanded)
                        const Spacer(),
                      if (canToggleExpand)
                        IconButton(
                          icon: Icon(isExpanded ? Icons.menu_open : Icons.menu),
                          tooltip: isExpanded
                              ? 'Collapse Sidebar'
                              : 'Expand Sidebar',
                          onPressed: onToggleExpand,
                        ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color:
                    config.dividerColor ??
                    theme.dividerColor.withValues(alpha: 0.12),
              ),

              // Destinations Navigation List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    if (item.isDivider) {
                      return Divider(
                        height: 16,
                        color:
                            config.dividerColor ??
                            theme.dividerColor.withValues(alpha: 0.12),
                      );
                    }

                    if (item.isHeader) {
                      if (!isExpanded) return const SizedBox(height: 8);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          item.label.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            letterSpacing: 1.1,
                          ),
                        ),
                      );
                    }

                    final isSelected = index == selectedIndex;

                    if (!isExpanded) {
                      // Collapsed icon-only mode
                      return _buildCollapsedItem(
                        context,
                        item,
                        index,
                        isSelected,
                        theme,
                      );
                    }

                    // Expanded mode
                    return _buildExpandedItem(
                      context,
                      item,
                      index,
                      isSelected,
                      theme,
                    );
                  },
                ),
              ),

              // Custom Sidebar Footer Slot
              if (sidebarFooter != null) ...[
                Divider(
                  height: 1,
                  color:
                      config.dividerColor ??
                      theme.dividerColor.withValues(alpha: 0.12),
                ),
                Padding(padding: const EdgeInsets.all(8), child: sidebarFooter),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedItem(
    BuildContext context,
    AdminNavItem item,
    int index,
    bool isSelected,
    ThemeData theme,
  ) {
    final iconColor = isSelected
        ? (config.selectedItemColor ?? theme.colorScheme.primary)
        : (config.unselectedItemColor ?? theme.colorScheme.onSurfaceVariant);

    Widget iconWidget = Icon(
      isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
      color: iconColor,
      size: 22,
    );

    if (item.badgeText != null) {
      iconWidget = Badge(
        label: Text(item.badgeText!),
        backgroundColor: item.badgeColor,
        child: iconWidget,
      );
    }

    // When collapsed, if item has children, show popup menu on tap
    if (item.hasChildren) {
      return PopupMenuButton<AdminNavItem>(
        tooltip: item.label,
        offset: const Offset(72, 0),
        onSelected: (child) => child.onTap?.call(),
        itemBuilder: (context) => item.children.map((child) {
          return PopupMenuItem<AdminNavItem>(
            value: child,
            child: Row(
              children: [
                Icon(child.icon, size: 18),
                const SizedBox(width: 12),
                Text(child.label),
              ],
            ),
          );
        }).toList(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          height: 48,
          decoration: BoxDecoration(
            color: isSelected
                ? (config.indicatorColor ??
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5))
                : Colors.transparent,
            borderRadius: config.itemBorderRadius,
          ),
          child: Center(child: iconWidget),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Tooltip(
        message: item.label,
        waitDuration: const Duration(milliseconds: 500),
        child: InkWell(
          borderRadius: config.itemBorderRadius,
          onTap: () {
            if (item.onTap != null) {
              item.onTap!();
            } else {
              onDestinationSelected(index);
            }
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? (config.indicatorColor ??
                        theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ))
                  : Colors.transparent,
              borderRadius: config.itemBorderRadius,
            ),
            child: Center(child: iconWidget),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedItem(
    BuildContext context,
    AdminNavItem item,
    int index,
    bool isSelected,
    ThemeData theme,
  ) {
    if (item.hasChildren) {
      return ExpansionTile(
        key: ValueKey(item.id),
        leading: Icon(
          item.icon,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
        title: Text(
          item.label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        childrenPadding: EdgeInsets.zero,
        initiallyExpanded: isSelected,
        children: item.children.map((child) {
          return ListTile(
            contentPadding: const EdgeInsets.only(left: 56, right: 16),
            dense: true,
            leading: Icon(child.icon, size: 18),
            title: Text(child.label, style: const TextStyle(fontSize: 13)),
            trailing: child.badgeText != null ? _buildBadge(child) : null,
            onTap: () => child.onTap?.call(),
          );
        }).toList(),
      );
    }

    final isHighlighted = isSelected;
    final fgColor = isHighlighted
        ? (config.selectedItemColor ?? theme.colorScheme.primary)
        : (config.unselectedItemColor ?? theme.colorScheme.onSurface);

    return Padding(
      padding: config.itemPadding,
      child: Material(
        color: isHighlighted
            ? (config.indicatorColor ??
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.6))
            : Colors.transparent,
        borderRadius: config.itemBorderRadius,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: config.dense,
          shape: RoundedRectangleBorder(borderRadius: config.itemBorderRadius),
          leading: Icon(
            isHighlighted ? (item.selectedIcon ?? item.icon) : item.icon,
            color: fgColor,
            size: 22,
          ),
          title: Text(
            item.label,
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
              color: fgColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: item.badgeText != null ? _buildBadge(item) : null,
          onTap: () {
            if (item.onTap != null) {
              item.onTap!();
            } else {
              onDestinationSelected(index);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBadge(AdminNavItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: item.badgeColor ?? Colors.red.shade600,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Text(
        item.badgeText!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
