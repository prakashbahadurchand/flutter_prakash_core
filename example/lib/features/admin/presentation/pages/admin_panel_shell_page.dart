import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/core/router/app_router.dart';
import '../../../../core/di/injection.dart';

@RoutePage()
class AdminPanelShellPage extends StatelessWidget {
  const AdminPanelShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    const navItems = <AdminNavItem>[
      AdminNavItem(
        label: 'Overview',
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view_rounded,
        route: AdminOverviewRoute(),
      ),
      AdminNavItem(
        label: 'Analytics',
        icon: Icons.analytics_outlined,
        selectedIcon: Icons.analytics,
        badgeText: 'Live',
        badgeColor: Colors.green,
        route: AdminAnalyticsRoute(),
      ),
      AdminNavItem(
        label: 'Orders',
        icon: Icons.shopping_bag_outlined,
        selectedIcon: Icons.shopping_bag,
        badgeText: '12',
        route: AdminOrdersRoute(),
      ),
      AdminNavItem(
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: AdminSettingsRoute(),
      ),
    ];

    return AutoTabsRouter(
      routes: navItems.map((item) => item.route).toList(),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final theme = Theme.of(context);

        return AdminPanelScaffold(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: (index) => tabsRouter.setActiveIndex(index),
          items: navItems,
          brandHeader: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.admin_panel_settings, size: 28, color: Colors.indigo),
              SizedBox(width: 8),
              Text(
                'Enterprise',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          headerActions: [
            // Theme Toggle Button
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

            // Notifications Icon
            IconButton(
              icon: const Badge(
                label: Text('3'),
                child: Icon(Icons.notifications_outlined),
              ),
              tooltip: 'Notifications',
              onPressed: () {},
            ),
          ],
          userProfileHeader: PopupMenuButton<String>(
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
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
                  // Navigate to profile
                  break;
                case 'settings':
                  tabsRouter.setActiveIndex(3); // Navigate to Settings tab
                  break;
                case 'logout':
                  // Perform logout
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
                    const SizedBox(width: 12),
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
