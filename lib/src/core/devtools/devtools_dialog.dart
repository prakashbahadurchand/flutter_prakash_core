import 'package:flutter/material.dart';
import 'package:flutter_prakash/src/core/devtools/devtools_appdata_storage_tabview.dart';
import 'package:flutter_prakash/src/core/devtools/devtools_custom_options_tabview.dart';
import 'package:flutter_prakash/src/core/devtools/devtools_graphql_inspector_tabview.dart';
import 'package:flutter_prakash/src/core/devtools/devtools_logger_tabview.dart';
import 'package:flutter_prakash/src/core/devtools/devtools_networking_inspector_tabview.dart';
import 'package:flutter_prakash/src/core/devtools/devtools_preferences_tabview.dart';

/// Production-ready DevTools Dialog for inspecting REST APIs, GraphQL, Loggers, SharedPreferences/SecureStorage, and AppData files.
class DevToolsDialog extends StatefulWidget {
  const DevToolsDialog({super.key});

  /// Opens the DevTools dialog modal.
  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_) => const DevToolsDialog(),
      );

  @override
  State<DevToolsDialog> createState() => _DevToolsDialogState();
}

class _DevToolsDialogState extends State<DevToolsDialog>
    with SingleTickerProviderStateMixin {
  static const int _tabCount = 6;
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(
      length: _tabCount,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980, maxHeight: 780),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  const Icon(Icons.build, size: 18),
                  const SizedBox(width: 8),
                  Text('DevTools', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Material(
              color: theme.colorScheme.surface,
              child: TabBar(
                controller: _tab,
                isScrollable: true,
                tabs: const [
                  Tab(icon: Icon(Icons.settings), text: 'Custom'),
                  Tab(icon: Icon(Icons.network_check), text: 'REST API'),
                  Tab(icon: Icon(Icons.graphic_eq), text: 'GraphQL'),
                  Tab(icon: Icon(Icons.receipt_long), text: 'Logger'),
                  Tab(icon: Icon(Icons.tune), text: 'Prefs'),
                  Tab(icon: Icon(Icons.folder_copy), text: 'AppData'),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  DevtoolsCustomOptionsTabView(),
                  DevtoolsRetrofitNetworkingInspectorTabView(),
                  DevtoolsGraphqlInspectorTabView(),
                  DevtoolsLoggerTabView(),
                  DevtoolsPreferencesTabView(),
                  DevtoolsAppDataStorageTabView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
