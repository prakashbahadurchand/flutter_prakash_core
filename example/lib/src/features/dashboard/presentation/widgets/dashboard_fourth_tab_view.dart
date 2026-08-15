import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/config/routes/app_router.dart';
import 'package:flutter_prakash_example/src/features/dashboard/presentation/blocs/dashboard_cubit.dart';
import 'package:flutter_prakash_example/src/features/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:flutter_prakash_example/src/core/localization/locale_cubit.dart';
import 'package:flutter_prakash_example/src/core/theme/theme_cubit.dart';
import 'package:flutter_prakash_example/src/core/theme/app_colors.dart';

class DashboardFourthTabView extends StatelessWidget {
  final DashboardState state;

  const DashboardFourthTabView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cubit = context.read<DashboardCubit>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // Profile Hero Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Fake.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'developer@prakash.dev',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'PRO ACCOUNT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Section 1: Appearance & Localization
        _buildSectionHeader(context, 'Appearance & Localization'),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.palette_outlined,
              iconColor: AppPalette.primary,
              title: 'App Theme',
              subtitle: 'Select system, light, or dark mode',
              trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<ThemeMode>(
                      value: themeMode,
                      borderRadius: BorderRadius.circular(16),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode != null) {
                          context.read<ThemeCubit>().updateThemeMode(mode);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.language_rounded,
              iconColor: AppPalette.success,
              title: 'Language',
              subtitle: 'Select your preferred language',
              trailing: BlocBuilder<LocaleCubit, Locale>(
                builder: (context, currentLocale) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: currentLocale,
                      borderRadius: BorderRadius.circular(16),
                      items: const [
                        DropdownMenuItem(
                          value: Locale('en', 'US'),
                          child: Text('English (US)'),
                        ),
                        DropdownMenuItem(
                          value: Locale('ne', 'NP'),
                          child: Text('Nepali (NP)'),
                        ),
                      ],
                      onChanged: (loc) {
                        if (loc != null) {
                          context.read<LocaleCubit>().updateLocale(loc);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Section 2: Preferences & Security (Cubit Switched)
        _buildSectionHeader(context, 'Security & Privacy'),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.fingerprint_rounded,
              iconColor: AppPalette.secondary,
              title: 'Biometric Login',
              subtitle: 'Use Fingerprint or Face ID for fast sign-in',
              trailing: Switch.adaptive(
                value: state.biometricsEnabled,
                onChanged: cubit.toggleBiometrics,
              ),
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.notifications_active_outlined,
              iconColor: AppPalette.warning,
              title: 'Push Notifications',
              subtitle: 'Receive alerts & real-time updates',
              trailing: Switch.adaptive(
                value: state.notificationsEnabled,
                onChanged: cubit.toggleNotifications,
              ),
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.analytics_outlined,
              iconColor: AppPalette.info,
              title: 'Usage Analytics',
              subtitle: 'Help improve engine reliability',
              trailing: Switch.adaptive(
                value: state.analyticsEnabled,
                onChanged: cubit.toggleAnalytics,
              ),
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.bug_report_outlined,
              iconColor: AppPalette.error,
              title: 'Crash Reporting',
              subtitle: 'Send non-fatal error reports',
              trailing: Switch.adaptive(
                value: state.crashlyticsEnabled,
                onChanged: cubit.toggleCrashlytics,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Section 3: Engine Utilities
        _buildSectionHeader(context, 'Storage & Maintenance'),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.cleaning_services_rounded,
              iconColor: AppPalette.pink,
              title: 'Clear Cache & Temp Files',
              subtitle: 'Free up local memory & storage',
              onTap: cubit.clearCache,
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.build_circle_outlined,
              iconColor: AppPalette.primary,
              title: 'Open DevTools',
              subtitle: 'Inspect state, network & performance',
              onTap: () => DevToolsDialog.show(context),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Section 4: About & Legal
        _buildSectionHeader(context, 'About & Legal'),
        const SizedBox(height: 10),
        _SettingsCard(
          children: [
            const _SettingsTile(
              icon: Icons.info_outline_rounded,
              iconColor: AppPalette.slate500,
              title: 'Engine Version',
              subtitle: '1.0.2 (Build 1) • Stable Engine Core',
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppPalette.slate500,
              title: 'Privacy Policy',
              subtitle: 'Read our client privacy terms',
              onTap: () => context.router.push(const PrivacyPolicyRoute()),
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.description_outlined,
              iconColor: AppPalette.slate500,
              title: 'Terms of Service',
              subtitle: 'Enterprise terms & licensing agreement',
              onTap: () => context.router.push(const TermsConditionsRoute()),
            ),
            const Divider(height: 1),
            _SettingsTile(
              icon: Icons.feedback_outlined,
              iconColor: AppPalette.slate500,
              title: 'Report Feedback',
              subtitle: 'Help us improve the app',
              onTap: () => context.router.push(const ReportFeedbackRoute()),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Sign Out Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? AppPalette.error.withValues(alpha: 0.15)
                : AppPalette.errorBg,
            foregroundColor: AppPalette.error,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppPalette.error.withValues(alpha: 0.3)),
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text('Confirm Logout'),
                content: const Text(
                  'Are you sure you want to sign out of this account?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppPalette.error,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.router.replace(const LoginRoute());
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text(
            'Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppPalette.surface(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            ?trailing,
            if (trailing == null && onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
