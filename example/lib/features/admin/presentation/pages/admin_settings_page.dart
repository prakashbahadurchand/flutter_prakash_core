import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';

@RoutePage()
class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _emailNotifications = true;
  bool _twoFactorAuth = true;
  bool _autoBackup = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings & Preferences',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Security Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security & Authentication',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _twoFactorAuth,
                    onChanged: (val) => setState(() => _twoFactorAuth = val),
                    title: const Text(
                      'Enforce Two-Factor Authentication (2FA)',
                    ),
                    subtitle: const Text(
                      'Require all admin accounts to authenticate via SMS or Authenticator App.',
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    value: _autoBackup,
                    onChanged: (val) => setState(() => _autoBackup = val),
                    title: const Text('Automated Daily Database Backups'),
                    subtitle: const Text(
                      'Backup system Firestore data every night at 00:00 UTC.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Notifications Settings Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications & System Alerts',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _emailNotifications,
                    onChanged: (val) =>
                        setState(() => _emailNotifications = val),
                    title: const Text('Critical System Alerts via Email'),
                    subtitle: const Text(
                      'Receive immediate alerts when server crash logs or unauthorized logins occur.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Save Changes Action
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved successfully!')),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
