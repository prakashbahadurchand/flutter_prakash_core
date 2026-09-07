import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/dashboard_cubit.dart';
import 'package:flutter_prakash_core_example/features/dashboard/presentation/blocs/dashboard_state.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/widgets/settings_card.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/widgets/settings_tile.dart';

class DashboardFourthTabView extends StatelessWidget {
  const DashboardFourthTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final cubit = context.read<DashboardCubit>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      children: [
        // Profile Hero Header with dynamic user data
        BlocSelector<AuthCubit, AuthState, (String, String)>(
          selector: (authState) => switch (authState) {
            Authenticated(:final user) => (user.name, user.email),
            _ => ('Prakash B. Chand', 'prakash@chand.dev'),
          },
          builder: (context, userData) {
            final (name, email) = userData;

            return Container(
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
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 38,
                      color: AppPalette.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
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
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Verified Developer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // Section 1: Appearance & Theme
        _buildSectionHeader(context, 'Appearance & Localization'),
        const SizedBox(height: 10),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.palette_outlined,
              iconColor: AppPalette.primary,
              title: 'Theme Mode',
              subtitle: 'System, Light or Dark Mode',
              trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, currentMode) {
                  return SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode, size: 16),
                      ),
                    ],
                    selected: {currentMode},
                    onSelectionChanged: (Set<ThemeMode> newSelection) {
                      context.read<ThemeCubit>().setThemeMode(
                        newSelection.first,
                      );
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            SettingsTile(
              icon: Icons.language_rounded,
              iconColor: AppPalette.primary,
              title: 'Language',
              subtitle: 'App translation and locale',
              trailing: BlocBuilder<LocaleCubit, Locale>(
                builder: (context, currentLocale) {
                  final supportedLocales = const [
                    Locale('en', 'US'),
                    Locale('hi', 'IN'),
                    Locale('ne', 'NP'),
                  ];
                  final selectedLocale = supportedLocales.firstWhere(
                    (loc) =>
                        loc == currentLocale ||
                        loc.languageCode == currentLocale.languageCode,
                    orElse: () => supportedLocales.first,
                  );
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<Locale>(
                      value: selectedLocale,
                      borderRadius: BorderRadius.circular(16),
                      items: const [
                        DropdownMenuItem(
                          value: Locale('en', 'US'),
                          child: Text('English (US)'),
                        ),
                        DropdownMenuItem(
                          value: Locale('hi', 'IN'),
                          child: Text('Hindi (IN)'),
                        ),
                        DropdownMenuItem(
                          value: Locale('ne', 'NP'),
                          child: Text('Nepali (NP)'),
                        ),
                      ],
                      onChanged: (loc) {
                        if (loc != null) {
                          context.read<LocaleCubit>().setLocale(loc);
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

        // Section 2: Preferences & Security
        _buildSectionHeader(context, 'Security & Privacy'),
        const SizedBox(height: 10),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.lock_reset_rounded,
              iconColor: AppPalette.primary,
              title: 'Change Password',
              subtitle: 'Update your account security password',
              onTap: () => context.router.push(const ChangePasswordRoute()),
            ),
            const Divider(height: 1),
            BlocSelector<DashboardCubit, DashboardState, bool>(
              selector: (s) => s.biometricsEnabled,
              builder: (context, biometricsEnabled) {
                return SettingsTile(
                  icon: Icons.fingerprint_rounded,
                  iconColor: AppPalette.secondary,
                  title: 'Biometric Login',
                  subtitle: 'Use Fingerprint or Face ID for fast sign-in',
                  trailing: Switch.adaptive(
                    value: biometricsEnabled,
                    onChanged: cubit.toggleBiometrics,
                  ),
                );
              },
            ),
            const Divider(height: 1),
            BlocSelector<DashboardCubit, DashboardState, bool>(
              selector: (s) => s.notificationsEnabled,
              builder: (context, notificationsEnabled) {
                return SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  iconColor: AppPalette.warning,
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts & real-time updates',
                  trailing: Switch.adaptive(
                    value: notificationsEnabled,
                    onChanged: cubit.toggleNotifications,
                  ),
                );
              },
            ),
            const Divider(height: 1),
            BlocSelector<DashboardCubit, DashboardState, bool>(
              selector: (s) => s.analyticsEnabled,
              builder: (context, analyticsEnabled) {
                return SettingsTile(
                  icon: Icons.analytics_outlined,
                  iconColor: AppPalette.info,
                  title: 'Usage Analytics',
                  subtitle: 'Help improve engine reliability',
                  trailing: Switch.adaptive(
                    value: analyticsEnabled,
                    onChanged: cubit.toggleAnalytics,
                  ),
                );
              },
            ),
            const Divider(height: 1),
            BlocSelector<DashboardCubit, DashboardState, bool>(
              selector: (s) => s.crashlyticsEnabled,
              builder: (context, crashlyticsEnabled) {
                return SettingsTile(
                  icon: Icons.bug_report_outlined,
                  iconColor: AppPalette.error,
                  title: 'Crash Reporting',
                  subtitle: 'Send non-fatal error reports',
                  trailing: Switch.adaptive(
                    value: crashlyticsEnabled,
                    onChanged: cubit.toggleCrashlytics,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Section 3: Engine Maintenance
        _buildSectionHeader(context, 'Storage & Maintenance'),
        const SizedBox(height: 10),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.cleaning_services_rounded,
              iconColor: AppPalette.pink,
              title: 'Clear Cache & Temp Files',
              subtitle: 'Free up local memory & storage',
              onTap: cubit.clearCache,
            ),
            const Divider(height: 1),
            SettingsTile(
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
        SettingsCard(
          children: [
            const SettingsTile(
              icon: Icons.info_outline_rounded,
              iconColor: AppPalette.slate500,
              title: 'Engine Version',
              subtitle:
                  '${AppConstants.appVersion} (Build ${AppConstants.appBuildNumber}) • Clean Core',
            ),
            const Divider(height: 1),
            SettingsTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: AppPalette.slate500,
              title: 'Privacy Policy',
              subtitle: 'Read our client privacy terms',
              onTap: () => context.router.push(const PrivacyPolicyRoute()),
            ),
            const Divider(height: 1),
            SettingsTile(
              icon: Icons.description_outlined,
              iconColor: AppPalette.slate500,
              title: 'Terms of Service',
              subtitle: 'Enterprise terms & licensing agreement',
              onTap: () => context.router.push(const TermsAndConditionsRoute()),
            ),
            const Divider(height: 1),
            SettingsTile(
              icon: Icons.feedback_outlined,
              iconColor: AppPalette.slate500,
              title: 'Report Feedback',
              subtitle: 'Help us improve the app',
              onTap: () => context.router.push(const FeedbackRoute()),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Sign Out Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () async {
            await getIt<AuthCubit>().logout();
            if (context.mounted) {
              context.router.replaceAll([const LoginRoute()]);
            }
          },
          icon: const Icon(Icons.logout_rounded),
          label: const Text(
            'Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),

        // Preview Onboarding Button for testing
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            context.router.replace(const OnboardingRoute());
          },
          icon: const Icon(Icons.restart_alt_rounded),
          label: const Text('Preview Onboarding Slides'),
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
