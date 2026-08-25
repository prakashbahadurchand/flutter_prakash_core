import 'package:flutter/material.dart';
import 'package:flutter_prakash/src/devtools/devtools_appdata_storage_tabview.dart';
import 'package:flutter_prakash/src/devtools/devtools_custom_options_tabview.dart';
import 'package:flutter_prakash/src/devtools/devtools_graphql_inspector_tabview.dart';
import 'package:flutter_prakash/src/devtools/devtools_logger_tabview.dart';
import 'package:flutter_prakash/src/devtools/devtools_networking_inspector_tabview.dart';
import 'package:flutter_prakash/src/devtools/devtools_preferences_tabview.dart';

/// Production-ready DevTools Dialog for inspecting REST APIs, GraphQL, Loggers, SharedPreferences/SecureStorage, and AppData files.
class DevToolsDialog extends StatefulWidget {
  const DevToolsDialog({super.key, this.customTheme});

  /// Custom theme override for the DevTools dialog.
  final ThemeData? customTheme;

  /// Tracks whether the DevTools dialog is currently open.
  static final ValueNotifier<bool> isOpen = ValueNotifier<bool>(false);

  /// Default dedicated dark theme designed specifically for developer tools.
  static ThemeData get defaultDevToolsTheme {
    const primaryColor = Color(0xFF0D99FF);
    const surfaceDark = Color(0xFF1E1E2E);
    const backgroundDark = Color(0xFF181825);
    const cardDark = Color(0xFF252538);
    const onSurface = Color(0xFFCDD6F4);
    const dividerColor = Color(0xFF313244);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      canvasColor: surfaceDark,
      cardColor: cardDark,
      dividerColor: dividerColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: Color(0xFF89B4FA),
        surface: surfaceDark,
        onSurface: onSurface,
        surfaceContainerHighest: cardDark,
        outline: dividerColor,
        error: Color(0xFFF38BA8),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceDark,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 1),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: Color(0xFFA6ADC8),
        indicatorColor: primaryColor,
        dividerColor: dividerColor,
      ),
      iconTheme: const IconThemeData(color: onSurface),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: onSurface, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: onSurface),
        bodyMedium: TextStyle(color: onSurface),
        bodySmall: TextStyle(color: Color(0xFFA6ADC8)),
        labelLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(color: onSurface),
        labelSmall: TextStyle(color: Color(0xFFA6ADC8)),
      ),
    );
  }

  /// Opens the DevTools dialog modal.
  static Future<void> show(
    BuildContext context, {
    GlobalKey<NavigatorState>? navigatorKey,
    ThemeData? customTheme,
    bool useRootNavigator = true,
  }) async {
    if (isOpen.value) return;
    isOpen.value = true;

    final nav =
        navigatorKey?.currentState ??
        Navigator.maybeOf(context, rootNavigator: useRootNavigator) ??
        Navigator.maybeOf(context, rootNavigator: !useRootNavigator);

    try {
      if (nav != null) {
        await showDialog<void>(
          context: nav.context,
          useRootNavigator: useRootNavigator,
          builder: (_) => DevToolsDialog(customTheme: customTheme),
        );
      } else {
        await showDialog<void>(
          context: context,
          useRootNavigator: useRootNavigator,
          builder: (_) => DevToolsDialog(customTheme: customTheme),
        );
      }
    } finally {
      isOpen.value = false;
    }
  }

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
    _tab = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme =
        widget.customTheme ?? DevToolsDialog.defaultDevToolsTheme;

    return Theme(
      data: effectiveTheme,
      child: Builder(
        builder: (dialogContext) {
          final theme = Theme.of(dialogContext);

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
                        Icon(
                          Icons.build,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text('DevTools', style: theme.textTheme.titleMedium),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
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
        },
      ),
    );
  }
}
