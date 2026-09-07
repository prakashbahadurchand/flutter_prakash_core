/// ---------------------------------------------------------------------------
/// 🏢 Company   : Softix Info Pvt. Ltd.
/// 📅 Created   : Sunday, March 22, 2026 • 01:13 PM
/// ---------------------------------------------------------------------------
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Simple in-memory devtools logger.
/// Use anywhere in app:
///   DevtoolsLogger.instance.i('Hello');
///   DevtoolsLogger.instance.e('Oops', error: err, stackTrace: st);
///
/// You can also bridge debugPrint:
///   DevtoolsLogger.instance.hookDebugPrint();
class DevtoolsLogger {
  DevtoolsLogger._();

  static final DevtoolsLogger instance = DevtoolsLogger._();

  final ValueNotifier<List<DevtoolsLogEntry>> entries =
      ValueNotifier<List<DevtoolsLogEntry>>(<DevtoolsLogEntry>[]);

  bool paused = false;

  // Keep bounded memory.
  int maxEntries = 1500;

  void clear() {
    entries.value = <DevtoolsLogEntry>[];
  }

  void log(
    DevtoolsLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (paused) return;

    final entry = DevtoolsLogEntry(
      time: DateTime.now(),
      level: level,
      message: message,
      error: error,
      stackTrace: stackTrace,
      tag: tag,
    );

    final current = entries.value;
    final next = List<DevtoolsLogEntry>.of(current)..add(entry);

    // Trim from the start if too big.
    if (next.length > maxEntries) {
      final overflow = next.length - maxEntries;
      next.removeRange(0, overflow);
    }

    entries.value = next;
  }

  void d(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) => log(
    DevtoolsLogLevel.debug,
    message,
    error: error,
    stackTrace: stackTrace,
    tag: tag,
  );

  void i(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) => log(
    DevtoolsLogLevel.info,
    message,
    error: error,
    stackTrace: stackTrace,
    tag: tag,
  );

  void w(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) => log(
    DevtoolsLogLevel.warn,
    message,
    error: error,
    stackTrace: stackTrace,
    tag: tag,
  );

  void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) => log(
    DevtoolsLogLevel.error,
    message,
    error: error,
    stackTrace: stackTrace,
    tag: tag,
  );

  void hookDebugPrint() {
    // Avoid double-hooking in hot reload scenarios
    if (_debugPrintHooked) return;
    _debugPrintHooked = true;

    debugPrint = (String? message, {int? wrapWidth}) {
      if (message == null) return;
      // Send to devtools logger
      log(DevtoolsLogLevel.debug, message, tag: 'debugPrint');
      // Also keep console output
      _originalDebugPrint(message, wrapWidth: wrapWidth);
    };
  }

  static bool _debugPrintHooked = false;
  static final DebugPrintCallback _originalDebugPrint = debugPrint;

  String exportText({DevtoolsLogLevel? minLevel, String? query}) {
    final list = entries.value;
    final q = (query ?? '').trim().toLowerCase();

    final filtered = list.where((e) {
      final okLevel = minLevel == null || e.level.index >= minLevel.index;
      if (!okLevel) return false;
      if (q.isEmpty) return true;

      final blob = e.toPlainText().toLowerCase();
      return blob.contains(q);
    }).toList();

    return filtered.map((e) => e.toPlainText()).join('\n');
  }
}

enum DevtoolsLogLevel { debug, info, warn, error }

extension _DevtoolsLogLevelX on DevtoolsLogLevel {
  String get label {
    switch (this) {
      case DevtoolsLogLevel.debug:
        return 'DEBUG';
      case DevtoolsLogLevel.info:
        return 'INFO';
      case DevtoolsLogLevel.warn:
        return 'WARN';
      case DevtoolsLogLevel.error:
        return 'ERROR';
    }
  }
}

@immutable
class DevtoolsLogEntry {
  const DevtoolsLogEntry({
    required this.time,
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
    this.tag,
  });

  final DateTime time;
  final DevtoolsLogLevel level;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final String? tag;

  String toPlainText() {
    final ts = time.toIso8601String();
    final t = (tag == null || tag!.trim().isEmpty) ? '' : ' [$tag]';
    final err = error == null ? '' : '\n  error: $error';
    final st = stackTrace == null ? '' : '\n  stack: $stackTrace';
    return '$ts ${level.label}$t: $message$err$st';
  }
}

class DevtoolsLoggerTabView extends StatefulWidget {
  const DevtoolsLoggerTabView({super.key});

  @override
  State<DevtoolsLoggerTabView> createState() => _DevtoolsLoggerTabViewState();
}

class _DevtoolsLoggerTabViewState extends State<DevtoolsLoggerTabView> {
  final _logger = DevtoolsLogger.instance;

  final _scroll = ScrollController();
  final _searchCtrl = TextEditingController();

  DevtoolsLogLevel? _minLevel;
  bool _autoScroll = true;

  StreamSubscription<void>? _postFrameSub;

  @override
  void initState() {
    super.initState();

    // Optional: capture debugPrint into this logger tab (safe even if you don't call it).
    // Uncomment if you want it ALWAYS:
    // _logger.hookDebugPrint();

    _logger.entries.addListener(_onLogsChanged);
  }

  void _onLogsChanged() {
    if (!_autoScroll) return;
    if (!mounted) return;

    // If user is searching, don’t yank the scroll.
    if (_searchCtrl.text.trim().isNotEmpty) return;

    // Post-frame jump to bottom.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _logger.entries.removeListener(_onLogsChanged);
    unawaited(_postFrameSub?.cancel());
    _scroll.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<DevtoolsLogEntry> _filtered(List<DevtoolsLogEntry> all) {
    final q = _searchCtrl.text.trim().toLowerCase();

    return all.where((e) {
      final okLevel = _minLevel == null || e.level.index >= _minLevel!.index;
      if (!okLevel) return false;

      if (q.isEmpty) return true;
      return e.toPlainText().toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _copyFiltered() async {
    final text = _logger.exportText(
      minLevel: _minLevel,
      query: _searchCtrl.text,
    );
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied ${text.isEmpty ? 0 : text.split('\n').length} lines',
        ),
      ),
    );
  }

  Future<void> _copyLatestLine() async {
    final list = _logger.entries.value;
    if (list.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: list.last.toPlainText()));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied latest log line')));
  }

  // Color _levelColor(ThemeData theme, DevtoolsLogLevel level) {
  //   switch (level) {
  //     case DevtoolsLogLevel.debug:
  //       return theme.colorScheme.onSurfaceVariant;
  //     case DevtoolsLogLevel.info:
  //       return theme.colorScheme.primary;
  //     case DevtoolsLogLevel.warn:
  //       return theme.colorScheme.tertiary;
  //     case DevtoolsLogLevel.error:
  //       return theme.colorScheme.error;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _Toolbar(
            minLevel: _minLevel,
            onMinLevelChanged: (v) => setState(() => _minLevel = v),
            searchCtrl: _searchCtrl,
            onSearchChanged: (_) => setState(() {}),
            paused: _logger.paused,
            onTogglePause: () =>
                setState(() => _logger.paused = !_logger.paused),
            autoScroll: _autoScroll,
            onToggleAutoScroll: () =>
                setState(() => _autoScroll = !_autoScroll),
            onClear: () => setState(_logger.clear),
            onCopyFiltered: _copyFiltered,
            onCopyLatest: _copyLatestLine,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ValueListenableBuilder<List<DevtoolsLogEntry>>(
              valueListenable: _logger.entries,
              builder: (context, all, _) {
                final list = _filtered(all);

                if (list.isEmpty) {
                  return _EmptyState(
                    paused: _logger.paused,
                    hasAny: all.isNotEmpty,
                    theme: theme,
                  );
                }

                return DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final sn = i + 1;
                        final e = list[i];
                        // final levelColor = _levelColor(theme, e.level);

                        return InkWell(
                          onLongPress: () async {
                            await Clipboard.setData(
                              ClipboardData(text: e.toPlainText()),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied log entry')),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: SelectableText(
                                '$sn. ${_formatLine(e)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tip: long-press any row to copy. Use DevtoolsLogger.instance.{d/i/w/e}() from anywhere.',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatLine(DevtoolsLogEntry e) {
    // final time = _hhmmss(e.time);
    // final tag = (e.tag == null || e.tag!.trim().isEmpty) ? '' : ' [${e.tag}]';
    final err = e.error == null ? '' : ' | error: ${e.error}';
    // Keep list view compact; stacktrace is available via export/copy row.
    return '${e.message}$err';
  }

  // String _hhmmss(DateTime t) {
  //   String two(int n) => n.toString().padLeft(2, '0');
  //   return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  // }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.minLevel,
    required this.onMinLevelChanged,
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.paused,
    required this.onTogglePause,
    required this.autoScroll,
    required this.onToggleAutoScroll,
    required this.onClear,
    required this.onCopyFiltered,
    required this.onCopyLatest,
  });

  final DevtoolsLogLevel? minLevel;
  final ValueChanged<DevtoolsLogLevel?> onMinLevelChanged;

  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;

  final bool paused;
  final VoidCallback onTogglePause;

  final bool autoScroll;
  final VoidCallback onToggleAutoScroll;

  final VoidCallback onClear;
  final Future<void> Function() onCopyFiltered;
  final Future<void> Function() onCopyLatest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        IntrinsicWidth(
          child: DropdownButtonFormField<DevtoolsLogLevel?>(
            initialValue: minLevel,
            decoration: const InputDecoration(
              labelText: 'Min level',
              isDense: true,
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(child: Text('All')),
              DropdownMenuItem(
                value: DevtoolsLogLevel.debug,
                child: Text('DEBUG'),
              ),
              DropdownMenuItem(
                value: DevtoolsLogLevel.info,
                child: Text('INFO'),
              ),
              DropdownMenuItem(
                value: DevtoolsLogLevel.warn,
                child: Text('WARN'),
              ),
              DropdownMenuItem(
                value: DevtoolsLogLevel.error,
                child: Text('ERROR'),
              ),
            ],
            onChanged: onMinLevelChanged,
          ),
        ),
        SizedBox(
          width: 200,
          child: TextField(
            controller: searchCtrl,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              labelText: 'Search',
              isDense: true,
              border: const OutlineInputBorder(),
              suffixIcon: searchCtrl.text.isEmpty
                  ? const Icon(Icons.search)
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchCtrl.clear();
                        onSearchChanged('');
                      },
                    ),
            ),
          ),
        ),
        FilterChip(
          label: Text(paused ? 'Paused' : 'Live'),
          selected: paused,
          onSelected: (_) => onTogglePause(),
          avatar: Icon(paused ? Icons.pause : Icons.play_arrow, size: 18),
        ),
        FilterChip(
          label: const Text('Auto-scroll'),
          selected: autoScroll,
          onSelected: (_) => onToggleAutoScroll(),
          avatar: const Icon(Icons.vertical_align_bottom, size: 18),
        ),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Clear'),
        ),
        OutlinedButton.icon(
          onPressed: onCopyLatest,
          icon: const Icon(Icons.copy),
          label: const Text('Copy latest'),
        ),
        ElevatedButton.icon(
          onPressed: onCopyFiltered,
          icon: const Icon(Icons.content_copy),
          label: const Text('Copy filtered'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.paused,
    required this.hasAny,
    required this.theme,
  });

  final bool paused;
  final bool hasAny;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final title = hasAny
        ? 'No logs match your filters'
        : (paused ? 'Logger is paused' : 'No logs yet');

    final subtitle = hasAny
        ? 'Try clearing search / lowering min level.'
        : 'Use DevtoolsLogger.instance.i("...") or hook debugPrint to see logs here.';

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
