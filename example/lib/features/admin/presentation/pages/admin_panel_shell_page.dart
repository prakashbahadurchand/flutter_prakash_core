import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/core/router/app_router.dart';

@RoutePage()
class AdminPanelShellPage extends StatelessWidget {
  const AdminPanelShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    const navItems = <AdminNavItem>[
      AdminNavItem(
        id: 'overview',
        label: 'Overview',
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view_rounded,
        route: AdminOverviewRoute(),
        roles: ['admin', 'manager'],
      ),
      AdminNavItem(
        id: 'analytics',
        label: 'Analytics',
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        badgeText: 'Live',
        badgeColor: Colors.green,
        route: AdminAnalyticsRoute(),
        roles: ['admin'],
      ),
      AdminNavItem(
        id: 'orders',
        label: 'Orders',
        icon: Icons.shopping_bag_outlined,
        selectedIcon: Icons.shopping_bag,
        badgeText: '12',
        route: AdminOrdersRoute(),
        roles: ['admin', 'manager'],
      ),
      AdminNavItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: AdminSettingsRoute(),
        roles: ['admin'],
      ),
    ];

    return AutoTabsRouter(
      routes: navItems.map((item) => item.route!).toList(),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final theme = Theme.of(context);

        return AdminPanelScaffold(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          items: navItems,
          currentUserRoles: const ['admin'],
          themeConfig: const AdminThemeConfig.defaultConfig(),
          brandHeader: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 22,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prakash Core',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Enterprise Admin',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          sidebarFooter: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'v1.0.11 Production',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          headerActions: [
            // Theme Mode Toggle
            BlocBuilder<ThemeCubit, ThemeMode>(
              bloc: getIt<ThemeCubit>(),
              builder: (context, mode) {
                final isDark = mode == ThemeMode.dark;
                return IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                  ),
                  tooltip: isDark
                      ? 'Switch to Light Mode'
                      : 'Switch to Dark Mode',
                  onPressed: () => getIt<ThemeCubit>().toggleTheme(),
                );
              },
            ),

            // Notifications Icon with live counter
            IconButton(
              icon: const Badge(
                label: Text('3'),
                child: Icon(Icons.notifications_outlined),
              ),
              tooltip: 'Notifications',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('3 new notifications'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
          userProfileHeader: PopupMenuButton<String>(
            offset: const Offset(0, 48),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            tooltip: 'Account Settings',
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      'PC',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Prakash Chand',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Viewing Profile')),
                  );
                  break;
                case 'settings':
                  tabsRouter.setActiveIndex(3);
                  break;
                case 'logout':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logging out...')),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prakash Chand',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'admin@enterprise.com',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('My Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 20,
                      color: theme.colorScheme.error,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: child,
        );
      },
    );
  }
}
