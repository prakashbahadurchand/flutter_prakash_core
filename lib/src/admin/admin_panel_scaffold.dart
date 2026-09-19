import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'responsive.dart';

/// Navigation item schema for the Admin Scaffold.
class AdminNavItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final String? badgeText;
  final Color? badgeColor;
  final PageRouteInfo route;

  const AdminNavItem({
    required this.label,
    required this.icon,
    required this.route,
    this.selectedIcon,
    this.badgeText,
    this.badgeColor,
  });
}

/// Enterprise-grade layout scaffold with persistent top header profile & adaptive navigation.
class AdminPanelScaffold extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdminNavItem> items;
  final Widget body;

  /// Brand logo or title rendered at the top-left of the sidebar/drawer.
  final Widget? brandHeader;

  /// Profile widget rendered at the TOP-RIGHT of the desktop/tablet header.
  final Widget? userProfileHeader;

  /// Custom actions displayed alongside the top-right profile (e.g. notifications, search).
  final List<Widget>? headerActions;

  /// Optional custom page title displayed in the top header. Defaults to selected item label.
  final Widget? pageTitle;

  /// Custom Mobile AppBar override.
  final PreferredSizeWidget? appBar;

  final Color? backgroundColor;

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
    this.backgroundColor,
  });

  @override
  State<AdminPanelScaffold> createState() => _AdminPanelScaffoldState();
}

class _AdminPanelScaffoldState extends State<AdminPanelScaffold> {
  bool _isRailExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMobile = context.isMobile;
    final bool isDesktop = context.isDesktop;

    return Scaffold(
      appBar: isMobile
          ? (widget.appBar ?? _buildDefaultMobileAppBar(context))
          : null,
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      backgroundColor: widget.backgroundColor ?? theme.colorScheme.surface,
      body: Row(
        children: [
          // Desktop / Tablet Navigation Sidebar
          if (!isMobile) _buildDesktopSidebar(context, isDesktop),
          if (!isMobile)
            VerticalDivider(
              thickness: 1,
              width: 1,
              color: theme.dividerColor.withValues(alpha: 0.12),
            ),

          // Main Content Area with Top Header
          Expanded(
            child: Column(
              children: [
                // Persistent Top Header Bar (Desktop/Tablet Only)
                if (!isMobile) _buildTopHeaderBar(context),

                // Main Page Content
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
          ? NavigationBar(
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: widget.onDestinationSelected,
              destinations: widget.items
                  .map(
                    (item) => NavigationDestination(
                      icon: _buildIconWithBadge(item, false),
                      selectedIcon: _buildIconWithBadge(item, true),
                      label: item.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }

  /// Builds the persistent top header bar for Desktop and Tablet screens.
  Widget _buildTopHeaderBar(BuildContext context) {
    final theme = Theme.of(context);
    final currentItem = widget.items.length > widget.selectedIndex
        ? widget.items[widget.selectedIndex]
        : null;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.12),
            ),
          ),
        ),
        child: Row(
          children: [
            // Page Title / Section Name
            Expanded(
              child:
                  widget.pageTitle ??
                  Text(
                    currentItem?.label ?? '',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),

            // Custom Header Actions (Notifications, Search, Theme Toggle)
            if (widget.headerActions != null) ...[
              ...widget.headerActions!,
              const SizedBox(width: 12),
            ],

            // Top-Right User Profile Header
            if (widget.userProfileHeader != null) widget.userProfileHeader!,
          ],
        ),
      ),
    );
  }

  /// Builds the side navigation rail/drawer for desktop and tablet.
  Widget _buildDesktopSidebar(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final bool showExpanded = isDesktop && _isRailExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      width: showExpanded ? 260 : 72,
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            // Sidebar Header (Logo + Rail Toggle)
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  if (showExpanded && widget.brandHeader != null)
                    Expanded(child: widget.brandHeader!),
                  if (isDesktop)
                    IconButton(
                      icon: Icon(
                        _isRailExpanded ? Icons.menu_open : Icons.menu,
                      ),
                      tooltip: _isRailExpanded
                          ? 'Collapse Menu'
                          : 'Expand Menu',
                      onPressed: () =>
                          setState(() => _isRailExpanded = !_isRailExpanded),
                    ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.dividerColor.withValues(alpha: 0.12),
            ),

            // Navigation Destinations
            Expanded(
              child: NavigationRail(
                extended: showExpanded,
                minWidth: 72,
                minExtendedWidth: 260,
                backgroundColor: theme.colorScheme.surface,
                selectedIndex: widget.selectedIndex,
                onDestinationSelected: widget.onDestinationSelected,
                labelType: NavigationRailLabelType.none,
                useIndicator: true,
                indicatorColor: theme.colorScheme.primaryContainer,
                destinations: widget.items.map((item) {
                  return NavigationRailDestination(
                    icon: _buildIconWithBadge(item, false),
                    selectedIcon: _buildIconWithBadge(item, true),
                    label: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the slide-out navigation drawer for mobile.
  Widget _buildMobileDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child:
                  widget.brandHeader ??
                  Text('Admin Panel', style: theme.textTheme.headlineSmall),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = index == widget.selectedIndex;
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
                      ? _buildBadgeWidget(item)
                      : null,
                  selected: isSelected,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onDestinationSelected(index);
                  },
                );
              },
            ),
          ),

          // Drawer Footer Profile for Mobile View
          if (widget.userProfileHeader != null) ...[
            Divider(
              height: 1,
              color: theme.dividerColor.withValues(alpha: 0.12),
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

  PreferredSizeWidget _buildDefaultMobileAppBar(BuildContext context) {
    final currentItem = widget.items.length > widget.selectedIndex
        ? widget.items[widget.selectedIndex]
        : null;

    return AppBar(
      title: Text(currentItem?.label ?? ''),
      centerTitle: true,
      actions: [
        if (widget.userProfileHeader != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: widget.userProfileHeader,
          ),
      ],
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

  Widget _buildBadgeWidget(AdminNavItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: item.badgeColor ?? Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        item.badgeText!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
