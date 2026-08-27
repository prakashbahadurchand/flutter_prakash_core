import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/settings_cubit.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/settings_state.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/widgets/settings_card.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/widgets/settings_tile.dart';

@RoutePage()
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<SettingsCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Settings'), centerTitle: true),
      body: BlocProvider.value(
        value: _cubit,
        child: PrakashEffectListener.fromCubit(
          cubit: _cubit,
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final prefs = state.preferences;

              return ListView(
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
                      SettingsTile(
                        icon: Icons.fingerprint_rounded,
                        iconColor: AppPalette.secondary,
                        title: 'Biometric Authentication',
                        subtitle: 'Use Face ID / Touch ID for quick sign-in',
                        trailing: Switch.adaptive(
                          value: prefs.biometricsEnabled,
                          onChanged: _cubit.toggleBiometrics,
                        ),
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.notifications_active_outlined,
                        iconColor: AppPalette.warning,
                        title: 'Push Notifications',
                        subtitle: 'Receive updates and account alerts',
                        trailing: Switch.adaptive(
                          value: prefs.notificationsEnabled,
                          onChanged: _cubit.toggleNotifications,
                        ),
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.analytics_outlined,
                        iconColor: AppPalette.info,
                        title: 'Anonymous Usage Analytics',
                        subtitle: 'Help improve stability and responsiveness',
                        trailing: Switch.adaptive(
                          value: prefs.analyticsEnabled,
                          onChanged: _cubit.toggleAnalytics,
                        ),
                      ),
                      const Divider(height: 1),
                      SettingsTile(
                        icon: Icons.bug_report_outlined,
                        iconColor: AppPalette.error,
                        title: 'Crashlytics Diagnostics',
                        subtitle: 'Automatically report crash logs',
                        trailing: Switch.adaptive(
                          value: prefs.crashlyticsEnabled,
                          onChanged: _cubit.toggleCrashlytics,
                        ),
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
              );
            },
          ),
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
