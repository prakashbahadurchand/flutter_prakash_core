import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/config/routes/app_router.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en', 'US');

  void _onThemeChanged(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _onLocaleChanged(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeTab(),
      _UtilitiesTab(),
      _NetworkTab(),
      _MediaTab(),
      _SettingsTab(
        currentTheme: _themeMode,
        currentLocale: _locale,
        onThemeChanged: _onThemeChanged,
        onLocaleChanged: _onLocaleChanged,
      ),
    ];

    return DevtoolsFloatingDock(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Prakash Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: () => DevToolsDialog.show(context),
            ),
          ],
        ),
        body: pages[_currentIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.build), label: 'Core'),
            NavigationDestination(icon: Icon(Icons.wifi), label: 'Network'),
            NavigationDestination(icon: Icon(Icons.perm_media), label: 'Media/Ads'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${Fake.fullName}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(Fake.email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                Text(Fake.paragraph),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Featured Fake Data Generator:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Phone Number'),
          subtitle: Text(Fake.phoneNumber),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text('GitHub Social Link'),
          subtitle: Text(Fake.socialLink('github')),
        ),
        ListTile(
          leading: const Icon(Icons.attach_money),
          title: const Text('Random Price'),
          subtitle: Text('\$${Fake.price(min: 10, max: 99)}'),
        ),
      ],
    );
  }
}

class _UtilitiesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton(
          onPressed: () {
            Toast.info('Success! Toast triggered.');
          },
          child: const Text('Show Success Toast'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            LoadingOverlay.show(autoHideInSeconds: 2);
          },
          child: const Text('Show Loading Overlay (2s)'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            logInfo('Testing top-level logInfo function', tag: 'EXAMPLE');
            logDebug({'key': 'value', 'count': 42}, tag: 'DEBUG_TEST');
            logWarn('This is a test warning', tag: 'WARN_TEST');
          },
          child: const Text('Trigger FlutterLogger Logs'),
        ),
      ],
    );
  }
}

class _NetworkTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.analytics, color: Colors.blue),
            title: const Text('Firebase Analytics Log'),
            subtitle: const Text('Tap to send custom event: test_button_click'),
            onTap: () {
              FirebaseAnalyticsManager.logEvent(
                name: 'test_button_click',
                parameters: {'screen': 'dashboard_network'},
              );
              Toast.info('Logged Analytics Event');
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.red),
            title: const Text('Record Non-Fatal Crashlytics Error'),
            subtitle: const Text('Captures error report via FirebaseCrashlyticsManager'),
            onTap: () {
              FirebaseCrashlyticsManager.recordError(
                Exception('Test non-fatal exception'),
                StackTrace.current,
                reason: 'Dashboard manual test',
              );
              Toast.error('Recorded Crashlytics Error');
            },
          ),
        ),
      ],
    );
  }
}

class _MediaTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('AdMob Banner Ad Demo:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        AdMobBannerWidget(
          adUnitId: AdMobTestIds.bannerAndroid,
          placeholder: Container(
            height: 50,
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: const Text('AdMob Banner Ad Placeholder'),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Adaptive Banner Ad Demo:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        AdMobAdaptiveBannerWidget(
          adUnitId: AdMobTestIds.bannerAndroid,
          placeholder: Container(
            height: 60,
            color: Colors.blue.shade100,
            alignment: Alignment.center,
            child: const Text('Adaptive Banner Placeholder'),
          ),
        ),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    required this.currentTheme,
    required this.currentLocale,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  final ThemeMode currentTheme;
  final Locale currentLocale;
  final ValueChanged<ThemeMode> onThemeChanged;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('Theme'),
          trailing: DropdownButton<ThemeMode>(
            value: currentTheme,
            onChanged: (mode) => mode != null ? onThemeChanged(mode) : null,
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          trailing: DropdownButton<Locale>(
            value: currentLocale,
            onChanged: (loc) => loc != null ? onLocaleChanged(loc) : null,
            items: const [
              DropdownMenuItem(value: Locale('en', 'US'), child: Text('English')),
              DropdownMenuItem(value: Locale('ne', 'NP'), child: Text('Nepali')),
            ],
          ),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('App Version'),
          subtitle: Text('1.0.2 (Build 1)'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('Privacy Policy'),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Privacy Policy'),
                content: const Text('Flutter Prakash processes data securely on-device.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                ],
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Terms & Conditions'),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Terms & Conditions'),
                content: const Text('Enterprise core engine terms of service.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                ],
              ),
            );
          },
        ),
        const Divider(),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.router.replace(const LoginRoute());
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ],
    );
  }
}
