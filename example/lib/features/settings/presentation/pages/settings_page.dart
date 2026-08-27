import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/settings_cubit.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/settings_state.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/widgets/settings_card.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/widgets/settings_tile.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('App Settings'), centerTitle: true),
      body: PrakashEffectListener.fromCubit(
        cubit: cubit,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionHeader(context, 'Appearance & Theme'),
            const SizedBox(height: 10),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.palette_outlined,
                  iconColor: AppPalette.primary,
                  title: 'Theme Mode',
                  subtitle: 'Choose between Light, Dark, or System mode',
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
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, 'Security & Notifications'),
            const SizedBox(height: 10),
            SettingsCard(
              children: [
                // Biometrics Switch (Rebuilds ONLY on biometricsEnabled changes)
                BlocSelector<SettingsCubit, SettingsState, bool>(
                  selector: (state) => state.preferences.biometricsEnabled,
                  builder: (context, biometricsEnabled) {
                    return SettingsTile(
                      icon: Icons.fingerprint_rounded,
                      iconColor: AppPalette.secondary,
                      title: 'Biometric Authentication',
                      subtitle: 'Use Face ID / Touch ID for quick sign-in',
                      trailing: Switch.adaptive(
                        value: biometricsEnabled,
                        onChanged: cubit.toggleBiometrics,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),

                // Push Notifications Switch (Rebuilds ONLY on notificationsEnabled changes)
                BlocSelector<SettingsCubit, SettingsState, bool>(
                  selector: (state) => state.preferences.notificationsEnabled,
                  builder: (context, notificationsEnabled) {
                    return SettingsTile(
                      icon: Icons.notifications_active_outlined,
                      iconColor: AppPalette.warning,
                      title: 'Push Notifications',
                      subtitle: 'Receive updates and account alerts',
                      trailing: Switch.adaptive(
                        value: notificationsEnabled,
                        onChanged: cubit.toggleNotifications,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),

                // Analytics Switch (Rebuilds ONLY on analyticsEnabled changes)
                BlocSelector<SettingsCubit, SettingsState, bool>(
                  selector: (state) => state.preferences.analyticsEnabled,
                  builder: (context, analyticsEnabled) {
                    return SettingsTile(
                      icon: Icons.analytics_outlined,
                      iconColor: AppPalette.info,
                      title: 'Anonymous Usage Analytics',
                      subtitle: 'Help improve stability and responsiveness',
                      trailing: Switch.adaptive(
                        value: analyticsEnabled,
                        onChanged: cubit.toggleAnalytics,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),

                // Crashlytics Switch (Rebuilds ONLY on crashlyticsEnabled changes)
                BlocSelector<SettingsCubit, SettingsState, bool>(
                  selector: (state) => state.preferences.crashlyticsEnabled,
                  builder: (context, crashlyticsEnabled) {
                    return SettingsTile(
                      icon: Icons.bug_report_outlined,
                      iconColor: AppPalette.error,
                      title: 'Crashlytics Diagnostics',
                      subtitle: 'Automatically report crash logs',
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

            _buildSectionHeader(context, 'Legal & Information'),
            const SizedBox(height: 10),
            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: AppPalette.slate500,
                  title: 'Privacy Policy',
                  subtitle: 'Read our client privacy terms',
                  onTap: () => context.router.push(
                    const PrivacyPolicyRoute(),
                  ),
                ),
                const Divider(height: 1),
                SettingsTile(
                  icon: Icons.description_outlined,
                  iconColor: AppPalette.slate500,
                  title: 'Terms of Service',
                  subtitle: 'Enterprise terms & licensing agreement',
                  onTap: () => context.router.push(
                    const TermsAndConditionsRoute(),
                  ),
                ),
                const Divider(height: 1),
                SettingsTile(
                  icon: Icons.feedback_outlined,
                  iconColor: AppPalette.slate500,
                  title: 'Send Feedback',
                  subtitle: 'Help us improve the engine',
                  onTap: () => context.router.push(
                    const FeedbackRoute(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
