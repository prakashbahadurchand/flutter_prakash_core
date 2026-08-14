import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

class DashboardThirdTabView extends StatelessWidget {
  const DashboardThirdTabView({super.key});

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
        const SizedBox(height: 24),
        const Text(
          'Network & Analytics Engines',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bolt, color: Colors.teal),
            title: const Text('Supabase Engine Status'),
            subtitle: const Text('Configured for Auth, Realtime DB & Storage'),
            onTap: () {
              Toast.info('Supabase Engine is active & ready');
            },
          ),
        ),
        const SizedBox(height: 8),
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
        const SizedBox(height: 8),
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

/// Tab 4: Modern Premium Settings Tab (Fully Cubit-driven)
