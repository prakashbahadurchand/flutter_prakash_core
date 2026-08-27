/// ---------------------------------------------------------------------------
/// 🏢 Company   : Softix Info Pvt. Ltd.
/// 📅 Created   : Sunday, March 22, 2026 • 01:13 PM
/// ---------------------------------------------------------------------------
library;

// devtools_retrofit_networking_inspector_tabview.dart
//
// ✅ Better mobile-first UI/UX (also works on tablet/desktop):
// - On small screens: list → tap opens details in a bottom sheet (full height)
// - On wide screens: split view (list left, details right)
// - Sticky top toolbar + compact filters
// - Details: Segmented tabs (Overview / Request / Response / Error)
// - Pretty + colorful JSON (same lightweight highlighter)
// - Copy buttons grouped in a small action row
// - Optional: pause/resume capture, max entries selector (compact)
//
// Drop-in replacement for your current file.
// (Interceptor + models are same, UI updated for mobile friendliness.)

// ignore_for_file: strict_raw_type

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* -------------------------------------------------------------------------- */
/*                               Controller/Model                              */
/* -------------------------------------------------------------------------- */

class DevtoolsNetworkInspectorController extends ChangeNotifier {
  DevtoolsNetworkInspectorController._();
  static final DevtoolsNetworkInspectorController instance =
      DevtoolsNetworkInspectorController._();

  final List<DevtoolsNetEntry> _entries = [];
  List<DevtoolsNetEntry> get entries => List.unmodifiable(_entries);

  int maxEntries = 250;
  bool paused = false;

  void clear() {
    _entries.clear();
    notifyListeners();
  }

  void setPaused(bool v) {
    paused = v;
    notifyListeners();
  }

  void add(DevtoolsNetEntry entry) {
    if (paused) return;
    _entries.insert(0, entry);
    if (_entries.length > maxEntries) {
      _entries.removeRange(maxEntries, _entries.length);
    }
    notifyListeners();
  }

  void update(String id, DevtoolsNetEntry entry) {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    _entries[idx] = entry;
    notifyListeners();
  }
}

class DevtoolsNetworkInspectorInterceptor extends Interceptor {
  DevtoolsNetworkInspectorInterceptor({
    required this.controller,
    this.enabled = true,
    this.captureHeaders = true,
    this.captureRequestBody = true,
    this.captureResponseBody = true,
    this.maxBodyChars = 25000,
  });

  final DevtoolsNetworkInspectorController controller;
  final bool enabled;

  final bool captureHeaders;
  final bool captureRequestBody;
  final bool captureResponseBody;
  final int maxBodyChars;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled) return handler.next(options);

    final now = DateTime.now();
    final id = _findId(options, now);

    controller.add(
      DevtoolsNetEntry(
        id: id,
        startedAt: now,
        method: options.method,
        baseUrl: options.baseUrl,
        path: options.path,
        uri: options.uri,
        queryParameters: Map<String, dynamic>.from(options.queryParameters),
        requestHeaders: captureHeaders
            ? _sanitizeHeaders(options.headers)
            : const {},
        requestContentType: options.contentType?.toString(),
        requestBody: captureRequestBody ? _safeBody(options.data) : null,
        requestExtra: _safeExtras(options.extra),
        requestTag: options.extra['devtools_tag']?.toString(),
      ),
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled) return handler.next(response);

    final id = _findId(response.requestOptions);
    final finishedAt = DateTime.now();
    final prev = _getById(id);
    if (prev == null) return handler.next(response);

    controller.update(
      id,
      prev.copyWith(
        finishedAt: finishedAt,
        durationMs: finishedAt.difference(prev.startedAt).inMilliseconds,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        responseHeaders: captureHeaders
            ? _sanitizeHeaders(response.headers.map)
            : const {},
        responseBody: captureResponseBody ? _safeBody(response.data) : null,
        isSuccess:
            (response.statusCode ?? 0) >= 200 &&
            (response.statusCode ?? 0) < 300,
      ),
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!enabled) return handler.next(err);

    final id = _findId(err.requestOptions);
    final finishedAt = DateTime.now();
    final prev = _getById(id);
    if (prev == null) return handler.next(err);

    controller.update(
      id,
      prev.copyWith(
        finishedAt: finishedAt,
        durationMs: finishedAt.difference(prev.startedAt).inMilliseconds,
        statusCode: err.response?.statusCode,
        statusMessage: err.response?.statusMessage,
        responseHeaders: captureHeaders
            ? _sanitizeHeaders(err.response?.headers.map ?? const {})
            : const {},
        responseBody: captureResponseBody
            ? _safeBody(err.response?.data)
            : null,
        isSuccess: false,
        errorType: err.type.toString(),
        errorMessage: err.message,
      ),
    );

    handler.next(err);
  }

  DevtoolsNetEntry? _getById(String id) {
    try {
      return controller.entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  String _makeId(DateTime now, RequestOptions o) =>
      '${now.microsecondsSinceEpoch}_${o.method}_${o.uri}';

  String _findId(RequestOptions o, [DateTime? now]) {
    final existing = o.extra['_devtools_inspector_id']?.toString();
    if (existing != null) return existing;
    final id = _makeId(now ?? DateTime.now(), o);
    o.extra['_devtools_inspector_id'] = id;
    return id;
  }

  Map<String, dynamic> _sanitizeHeaders(Map<dynamic, dynamic> raw) {
    final out = <String, dynamic>{};
    for (final MapEntry(key: k, value: v) in raw.entries) {
      final key = k.toString();
      final lk = key.toLowerCase();
      if (lk.contains('authorization') ||
          lk.contains('token') ||
          lk.contains('cookie')) {
        out[key] = _maskValue(v);
      } else {
        out[key] = v;
      }
    }
    return out;
  }

  String _maskValue(dynamic v) {
    final s = v?.toString() ?? '';
    if (s.length <= 10) return '***';
    return '${s.substring(0, 4)}…${s.substring(s.length - 3)}';
  }

  Map<String, dynamic> _safeExtras(Map<String, dynamic> extra) {
    final out = <String, dynamic>{};
    for (final MapEntry(key: k, value: v) in extra.entries) {
      if (k == '_devtools_inspector_id') continue;
      out[k] = _safeAny(v, 8000);
    }
    return out;
  }

  dynamic _safeBody(dynamic data) => _safeAny(data, maxBodyChars);

  dynamic _safeAny(dynamic data, int limit) {
    if (data == null) return null;
    if (data is Uint8List) return '<bytes: ${data.length}>';
    if (data is List<int>) return '<bytes: ${data.length}>';

    if (data is FormData) {
      return <String, dynamic>{
        'fields': data.fields
            .map<Map<String, dynamic>>((e) => {'name': e.key, 'value': e.value})
            .toList(),
        'files': data.files
            .map<Map<String, dynamic>>(
              (e) => {
                'name': e.key,
                'filename': e.value.filename,
                'contentType': e.value.contentType?.toString(),
                'length': e.value.length,
              },
            )
            .toList(),
      };
    }

    if (data is Map || data is List) {
      try {
        final s = jsonEncode(data);
        return (s.length > limit) ? '${s.substring(0, limit)}…' : data;
      } catch (_) {
        return data.toString();
      }
    }

    if (data is String) {
      return data.length > limit ? '${data.substring(0, limit)}…' : data;
    }

    final s = data.toString();
    return s.length > limit ? '${s.substring(0, limit)}…' : s;
  }
}

@immutable
class DevtoolsNetEntry {
  const DevtoolsNetEntry({
    required this.id,
    required this.startedAt,
    required this.method,
    required this.baseUrl,
    required this.path,
    required this.uri,
    required this.queryParameters,
    required this.requestHeaders,
    required this.requestContentType,
    required this.requestBody,
    required this.requestExtra,
    this.requestTag,
    this.finishedAt,
    this.durationMs,
    this.statusCode,
    this.statusMessage,
    this.responseHeaders = const {},
    this.responseBody,
    this.isSuccess,
    this.errorType,
    this.errorMessage,
  });

  final String id;

  final DateTime startedAt;
  final DateTime? finishedAt;
  final int? durationMs;

  final String method;
  final String baseUrl;
  final String path;
  final Uri uri;

  final Map<String, dynamic> queryParameters;

  final Map<String, dynamic> requestHeaders;
  final String? requestContentType;
  final dynamic requestBody;
  final Map<String, dynamic> requestExtra;
  final String? requestTag;

  final int? statusCode;
  final String? statusMessage;

  final Map<String, dynamic> responseHeaders;
  final dynamic responseBody;

  final bool? isSuccess;

  final String? errorType;
  final String? errorMessage;

  bool get inFlight => finishedAt == null;

  DevtoolsNetEntry copyWith({
    DateTime? finishedAt,
    int? durationMs,
    int? statusCode,
    String? statusMessage,
    Map<String, dynamic>? responseHeaders,
    dynamic responseBody,
    bool? isSuccess,
    String? errorType,
    String? errorMessage,
  }) => DevtoolsNetEntry(
    id: id,
    startedAt: startedAt,
    finishedAt: finishedAt ?? this.finishedAt,
    durationMs: durationMs ?? this.durationMs,
    method: method,
    baseUrl: baseUrl,
    path: path,
    uri: uri,
    queryParameters: queryParameters,
    requestHeaders: requestHeaders,
    requestContentType: requestContentType,
    requestBody: requestBody,
    requestExtra: requestExtra,
    requestTag: requestTag,
    statusCode: statusCode ?? this.statusCode,
    statusMessage: statusMessage ?? this.statusMessage,
    responseHeaders: responseHeaders ?? this.responseHeaders,
    responseBody: responseBody ?? this.responseBody,
    isSuccess: isSuccess ?? this.isSuccess,
    errorType: errorType ?? this.errorType,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

/* -------------------------------------------------------------------------- */
/*                                    UI                                      */
/* -------------------------------------------------------------------------- */

/// Semantic alias for [DevtoolsRetrofitNetworkingInspectorTabView].
typedef DevtoolsNetworkingInspectorTabView =
    DevtoolsRetrofitNetworkingInspectorTabView;

class DevtoolsRetrofitNetworkingInspectorTabView extends StatefulWidget {
  const DevtoolsRetrofitNetworkingInspectorTabView({
    super.key,
    this.controller,
    this.mobileSplitBreakpoint = 720,
  });

  final DevtoolsNetworkInspectorController? controller;

  /// < breakpoint: list only + details bottom sheet
  /// >= breakpoint: split view
  final double mobileSplitBreakpoint;

  @override
  State<DevtoolsRetrofitNetworkingInspectorTabView> createState() =>
      _DevtoolsRetrofitNetworkingInspectorTabViewState();
}

class _DevtoolsRetrofitNetworkingInspectorTabViewState
    extends State<DevtoolsRetrofitNetworkingInspectorTabView>
    with AutomaticKeepAliveClientMixin {
  DevtoolsNetworkInspectorController get _c =>
      widget.controller ?? DevtoolsNetworkInspectorController.instance;

  String _q = '';
  bool _onlyErrors = false;
  bool _onlyInFlight = false;

  String? _selectedId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _c.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _c.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (!mounted) return;
    setState(() {});
  }

  List<DevtoolsNetEntry> get _filtered {
    final q = _q.trim().toLowerCase();
    return _c.entries.where((e) {
      if (_onlyErrors && (e.isSuccess ?? true)) return false;
      if (_onlyInFlight && !e.inFlight) return false;
      if (q.isEmpty) return true;
      final hay = [
        e.method,
        e.uri.toString(),
        e.path,
        e.statusCode?.toString() ?? '',
        e.requestTag ?? '',
      ].join(' ').toLowerCase();
      return hay.contains(q);
    }).toList();
  }

  DevtoolsNetEntry? _selectedFrom(List<DevtoolsNetEntry> list) {
    if (_selectedId == null) return null;
    try {
      return list.firstWhere((e) => e.id == _selectedId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final list = _filtered;

    return LayoutBuilder(
      builder: (context, cts) {
        final isWide = cts.maxWidth >= widget.mobileSplitBreakpoint;

        // keep selection valid
        if (list.isNotEmpty &&
            (_selectedId == null ||
                !_c.entries.any((e) => e.id == _selectedId))) {
          _selectedId = list.first.id;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _Toolbar(
                paused: _c.paused,
                onTogglePaused: () => _c.setPaused(!_c.paused),
                onClear: () {
                  _c.clear();
                  setState(() => _selectedId = null);
                },
                onCopyLastCurl: list.isEmpty
                    ? null
                    : () async {
                        final curl = _asCurl(list.first);
                        await Clipboard.setData(ClipboardData(text: curl));
                        if (!context.mounted) return;
                        _snack(context, 'Copied cURL (latest)');
                      },
                onMaxEntries: (v) {
                  _c.maxEntries = v;
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  _c.notifyListeners();
                },
                maxEntries: _c.maxEntries,
              ),
              const SizedBox(height: 8),
              _FiltersRow(
                query: _q,
                onlyErrors: _onlyErrors,
                onlyInFlight: _onlyInFlight,
                onQuery: (v) => setState(() => _q = v),
                onErrors: (v) => setState(() => _onlyErrors = v),
                onInFlight: (v) => setState(() => _onlyInFlight = v),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: isWide
                    ? _SplitView(
                        list: list,
                        selectedId: _selectedId,
                        onSelect: (id) => setState(() => _selectedId = id),
                        selected: _selectedFrom(list),
                      )
                    : _MobileListOnly(
                        list: list,
                        selectedId: _selectedId,
                        onTapEntry: (e) async {
                          setState(() => _selectedId = e.id);
                          await _openDetailsSheet(context, e);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openDetailsSheet(
    BuildContext context,
    DevtoolsNetEntry entry,
  ) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _DetailsSheet(entry: entry),
  );

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                Mobile views                                */
/* -------------------------------------------------------------------------- */

class _MobileListOnly extends StatelessWidget {
  const _MobileListOnly({
    required this.list,
    required this.selectedId,
    required this.onTapEntry,
  });

  final List<DevtoolsNetEntry> list;
  final String? selectedId;
  final ValueChanged<DevtoolsNetEntry> onTapEntry;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const Center(child: Text('No network logs yet'));
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final e = list[i];
          return _EntryCompactTile(
            entry: e,
            selected: e.id == selectedId,
            onTap: () => onTapEntry(e),
          );
        },
      ),
    );
  }
}

class _DetailsSheet extends StatelessWidget {
  const _DetailsSheet({required this.entry});
  final DevtoolsNetEntry entry;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxH = MediaQuery.of(context).size.height * 0.92;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: maxH,
        child: _EntryDetails(entry: entry, showTopClose: true),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 Split view                                 */
/* -------------------------------------------------------------------------- */

class _SplitView extends StatelessWidget {
  const _SplitView({
    required this.list,
    required this.selectedId,
    required this.onSelect,
    required this.selected,
  });

  final List<DevtoolsNetEntry> list;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final DevtoolsNetEntry? selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Flexible(
          flex: 4,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: list.isEmpty
                ? const Center(child: Text('No network logs yet'))
                : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: theme.dividerColor),
                    itemBuilder: (context, i) {
                      final e = list[i];
                      return _EntryCompactTile(
                        entry: e,
                        selected: e.id == selectedId,
                        onTap: () => onSelect(e.id),
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 6,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: selected == null
                ? const Center(child: Text('Select a request'))
                : _EntryDetails(entry: selected!, showTopClose: false),
          ),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   Toolbar                                  */
/* -------------------------------------------------------------------------- */

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.paused,
    required this.onTogglePaused,
    required this.onClear,
    required this.onCopyLastCurl,
    required this.onMaxEntries,
    required this.maxEntries,
  });

  final bool paused;
  final VoidCallback onTogglePaused;
  final VoidCallback onClear;
  final VoidCallback? onCopyLastCurl;
  final ValueChanged<int> onMaxEntries;
  final int maxEntries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Icon(Icons.wifi_tethering, size: 18),
        const SizedBox(width: 8),
        Text('Networking', style: theme.textTheme.titleMedium),
        const Spacer(),

        // compact dropdown for max entries
        _CompactMenu<int>(
          tooltip: 'Max entries',
          icon: const Icon(Icons.layers),
          value: maxEntries,
          items: const [100, 250, 500, 1000],
          labelBuilder: (v) => 'Max: $v',
          onSelected: onMaxEntries,
        ),

        IconButton(
          tooltip: paused ? 'Resume capture' : 'Pause capture',
          onPressed: onTogglePaused,
          icon: Icon(paused ? Icons.play_arrow : Icons.pause),
        ),
        IconButton(
          tooltip: 'Copy cURL (latest)',
          onPressed: onCopyLastCurl,
          icon: const Icon(Icons.code),
        ),
        IconButton(
          tooltip: 'Clear',
          onPressed: onClear,
          icon: const Icon(Icons.delete_sweep),
        ),
      ],
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.query,
    required this.onlyErrors,
    required this.onlyInFlight,
    required this.onQuery,
    required this.onErrors,
    required this.onInFlight,
  });

  final String query;
  final bool onlyErrors;
  final bool onlyInFlight;

  final ValueChanged<String> onQuery;
  final ValueChanged<bool> onErrors;
  final ValueChanged<bool> onInFlight;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: TextField(
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search method / url / status / tag…',
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onChanged: onQuery,
        ),
      ),
      const SizedBox(width: 8),
      FilterChip(
        label: const Text('Errors'),
        selected: onlyErrors,
        onSelected: onErrors,
      ),
      const SizedBox(width: 8),
      FilterChip(
        label: const Text('In-flight'),
        selected: onlyInFlight,
        onSelected: onInFlight,
      ),
    ],
  );
}

/* -------------------------------------------------------------------------- */
/*                            Compact list tile (UX)                           */
/* -------------------------------------------------------------------------- */

class _EntryCompactTile extends StatelessWidget {
  const _EntryCompactTile({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final DevtoolsNetEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ok = entry.isSuccess == true;
    final inFlight = entry.inFlight;

    IconData icon;
    Color? iconColor;
    if (inFlight) {
      icon = Icons.sync;
      iconColor = theme.colorScheme.primary;
    } else if (ok) {
      icon = Icons.check_circle;
      iconColor = Colors.green;
    } else {
      icon = Icons.error;
      iconColor = theme.colorScheme.error;
    }

    final host = entry.uri.host.isEmpty ? entry.uri.toString() : entry.uri.host;
    final path = entry.uri.path.isEmpty ? '/' : entry.uri.path;

    final right = inFlight
        ? '…'
        : '${entry.statusCode ?? '—'} • ${entry.durationMs ?? 0}ms';

    final tag = entry.requestTag;
    final hasTag = tag != null && tag.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.07)
            : null,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top line: method + host + time/status
                  Row(
                    children: [
                      _MethodPill(method: entry.method),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          host,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(right, style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatSub(path, entry.uri.query),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  if (hasTag) ...[
                    const SizedBox(height: 6),
                    _TagChip(tag: tag),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSub(String path, String query) {
    if (query.isEmpty) return path;
    return '$path ?$query';
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag});
  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
      ),
      child: Text(
        tag,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MethodPill extends StatelessWidget {
  const _MethodPill({required this.method});
  final String method;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Text(
        method.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                  Details UI                                */
/* -------------------------------------------------------------------------- */

class _EntryDetails extends StatefulWidget {
  const _EntryDetails({required this.entry, required this.showTopClose});

  final DevtoolsNetEntry entry;
  final bool showTopClose;

  @override
  State<_EntryDetails> createState() => _EntryDetailsState();
}

enum _DetailsTab { overview, request, response, error }

class _EntryDetailsState extends State<_EntryDetails> {
  _DetailsTab _tab = _DetailsTab.response;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final theme = Theme.of(context);

    return Column(
      children: [
        // compact header
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 6),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e.method.toUpperCase()} ${e.uri.path.isEmpty ? '/' : e.uri.path}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      e.uri.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (widget.showTopClose)
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
        ),

        // action row (mobile friendly)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _ActionChip(
                icon: Icons.link,
                label: 'URL',
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: e.uri.toString()),
                  );
                  if (!context.mounted) return;
                  _snack(context, 'Copied URL');
                },
              ),
              _ActionChip(
                icon: Icons.code,
                label: 'cURL',
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: _asCurl(e)));
                  if (!context.mounted) return;
                  _snack(context, 'Copied cURL');
                },
              ),
              _ActionChip(
                icon: Icons.copy_all,
                label: 'Response',
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(text: _prettyText(e.responseBody)),
                  );
                  if (!context.mounted) return;
                  _snack(context, 'Copied response');
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // segmented tabs (better on mobile than TabBar)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _SegmentedTabs(
            value: _tab,
            onChanged: (v) => setState(() => _tab = v),
          ),
        ),

        const SizedBox(height: 8),
        const Divider(height: 1),

        Expanded(
          child: switch (_tab) {
            _DetailsTab.overview => _OverviewPane(entry: e),
            _DetailsTab.request => _RequestPane(entry: e),
            _DetailsTab.response => _ResponsePane(entry: e),
            _DetailsTab.error => _ErrorPane(entry: e),
          },
        ),
      ],
    );
  }

  static void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(label, style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.value, required this.onChanged});

  final _DetailsTab value;
  final ValueChanged<_DetailsTab> onChanged;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, cts) {
      final isTight = cts.maxWidth < 360;

      Widget btn(_DetailsTab v, IconData icon, String label) {
        final selected = value == v;
        return Expanded(
          child: InkWell(
            onTap: () => onChanged(v),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: isTight ? 6 : 10,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: selected ? FontWeight.w700 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              btn(_DetailsTab.overview, Icons.info_outline, 'Overview'),
              _segDivider(context),
              btn(_DetailsTab.request, Icons.upload, 'Request'),
              _segDivider(context),
              btn(_DetailsTab.response, Icons.download, 'Response'),
              _segDivider(context),
              btn(_DetailsTab.error, Icons.bug_report, 'Error'),
            ],
          ),
        ),
      );
    },
  );

  Widget _segDivider(BuildContext context) =>
      Container(width: 1, height: 44, color: Theme.of(context).dividerColor);
}

/* -------------------------------------------------------------------------- */
/*                                  Panes                                     */
/* -------------------------------------------------------------------------- */

class _OverviewPane extends StatelessWidget {
  const _OverviewPane({required this.entry});
  final DevtoolsNetEntry entry;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    final theme = Theme.of(context);

    final code = e.statusCode;
    final ok = e.isSuccess == true;
    final statusText = e.inFlight
        ? 'In-flight'
        : (code == null ? 'Done' : (ok ? 'OK $code' : 'Error $code'));

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _kv(theme, 'Status', statusText),
        _kv(theme, 'Duration', e.inFlight ? '—' : '${e.durationMs ?? 0} ms'),
        _kv(theme, 'Host', e.uri.host.isEmpty ? '—' : e.uri.host),
        _kv(theme, 'Path', e.uri.path.isEmpty ? '/' : e.uri.path),
        _kv(theme, 'Query', e.uri.query.isEmpty ? '—' : e.uri.query),
        _kv(theme, 'Started', _shortTime(e.startedAt)),
        _kv(
          theme,
          'Finished',
          e.finishedAt == null ? '—' : _shortTime(e.finishedAt!),
        ),
        _kv(theme, 'Tag', e.requestTag ?? '—'),
        const SizedBox(height: 10),
        if (e.requestExtra.isNotEmpty)
          _Section(
            title: 'Extra',
            child: _PrettyBlock(value: e.requestExtra),
          ),
      ],
    );
  }

  String _shortTime(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    final ss = d.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  Widget _kv(ThemeData theme, String k, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        SizedBox(
          width: 92,
          child: Text(
            k,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
        ),
        Expanded(child: Text(v, style: theme.textTheme.bodyMedium)),
      ],
    ),
  );
}

class _RequestPane extends StatelessWidget {
  const _RequestPane({required this.entry});
  final DevtoolsNetEntry entry;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _Section(
          title: 'Headers',
          trailing: _copyBtn(
            context,
            _prettyText(e.requestHeaders),
            'Copied headers',
          ),
          child: _PrettyBlock(value: e.requestHeaders),
        ),
        const SizedBox(height: 10),
        _Section(
          title: 'Query',
          trailing: _copyBtn(
            context,
            _prettyText(e.queryParameters),
            'Copied query',
          ),
          child: _PrettyBlock(value: e.queryParameters),
        ),
        const SizedBox(height: 10),
        _Section(
          title: 'Body',
          subtitle: e.requestContentType == null
              ? null
              : 'Content-Type: ${e.requestContentType}',
          trailing: _copyBtn(
            context,
            _prettyText(e.requestBody),
            'Copied body',
          ),
          child: _PrettyBlock(value: e.requestBody),
        ),
      ],
    );
  }

  Widget _copyBtn(BuildContext context, String text, String msg) => IconButton(
    tooltip: 'Copy',
    icon: const Icon(Icons.copy),
    onPressed: () async {
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    },
  );
}

class _ResponsePane extends StatefulWidget {
  const _ResponsePane({required this.entry});
  final DevtoolsNetEntry entry;

  @override
  State<_ResponsePane> createState() => _ResponsePaneState();
}

class _ResponsePaneState extends State<_ResponsePane> {
  bool _isResponseHeaderCollapsed = true;

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _Section(
          title: 'Headers',
          trailing: Row(
            mainAxisSize: .min,
            children: [
              IconButton(
                icon: Icon(
                  _isResponseHeaderCollapsed
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_up,
                ),
                onPressed: () {
                  setState(() {
                    _isResponseHeaderCollapsed = !_isResponseHeaderCollapsed;
                  });
                },
              ),
              _copyBtn(
                context,
                _prettyText(e.responseHeaders),
                'Copied headers',
              ),
            ],
          ),
          child: _isResponseHeaderCollapsed
              ? const SizedBox.shrink()
              : _PrettyBlock(value: e.responseHeaders),
        ),
        const SizedBox(height: 10),
        _Section(
          title: 'Body',
          trailing: _copyBtn(
            context,
            _prettyText(e.responseBody),
            'Copied body',
          ),
          child: _PrettyBlock(value: e.responseBody),
        ),
      ],
    );
  }

  Widget _copyBtn(BuildContext context, String text, String msg) => IconButton(
    tooltip: 'Copy',
    icon: const Icon(Icons.copy),
    onPressed: () async {
      await Clipboard.setData(ClipboardData(text: text));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    },
  );
}

class _ErrorPane extends StatelessWidget {
  const _ErrorPane({required this.entry});
  final DevtoolsNetEntry entry;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    final hasError = (e.isSuccess == false) && !e.inFlight;

    if (!hasError) return const Center(child: Text('No error'));

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _Section(
          title: 'Error',
          trailing: IconButton(
            tooltip: 'Copy',
            icon: const Icon(Icons.copy),
            onPressed: () async {
              final text = '${e.errorType ?? ''}\n${e.errorMessage ?? ''}';
              await Clipboard.setData(ClipboardData(text: text));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Copied error')));
            },
          ),
          child: _PrettyBlock(
            value: {
              'type': e.errorType,
              'message': e.errorMessage,
              'statusCode': e.statusCode,
              'statusMessage': e.statusMessage,
            },
          ),
        ),
        const SizedBox(height: 10),
        if (e.responseBody != null)
          _Section(
            title: 'Error response body',
            child: _PrettyBlock(value: e.responseBody),
          ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                           Pretty JSON + Highlight                           */
/* -------------------------------------------------------------------------- */

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            title: Text(title, style: theme.textTheme.titleSmall),
            subtitle: subtitle == null
                ? null
                : Text(subtitle!, style: theme.textTheme.bodySmall),
            trailing: trailing,
          ),
          Divider(height: 1, color: theme.dividerColor),
          Padding(padding: const EdgeInsets.all(10), child: child),
        ],
      ),
    );
  }
}

class _PrettyBlock extends StatelessWidget {
  const _PrettyBlock({required this.value});
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final text = _prettyText(value);
    final isJson = _looksLikeJson(text);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isJson
              ? _JsonHighlightedText(text: text)
              : SelectableText(
                  text.isEmpty ? '—' : text,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontFamilyFallback: const ['Courier', 'Menlo', 'Monaco'],
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
        ),
      ),
    );
  }
}

class _JsonHighlightedText extends StatelessWidget {
  const _JsonHighlightedText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final spans = _jsonToSpans(context, text);
    return SelectableText.rich(
      TextSpan(children: spans),
      style: const TextStyle(
        fontFamily: 'monospace',
        fontFamilyFallback: ['Courier', 'Menlo', 'Monaco'],
        fontSize: 13,
        height: 1.4,
      ),
    );
  }

  List<InlineSpan> _jsonToSpans(BuildContext context, String jsonText) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final base = TextStyle(
      fontFamily: 'monospace',
      fontSize: 13,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
    );

    // Refined "DevTools" inspired colors
    final keyStyle = base.copyWith(
      color: isDark ? const Color(0xFFD19A66) : const Color(0xFF881280),
      fontWeight: FontWeight.w600,
    );
    final strStyle = base.copyWith(
      color: isDark ? const Color(0xFF98C379) : const Color(0xFF111111),
    );
    final numStyle = base.copyWith(
      color: isDark ? const Color(0xFF61AFEF) : const Color(0xFF1C00CF),
    );
    final boolStyle = base.copyWith(
      color: isDark ? const Color(0xFFC678DD) : const Color(0xFF2100A5),
      fontWeight: FontWeight.w500,
    );
    final nullStyle = base.copyWith(
      color: isDark ? const Color(0xFF5C6370) : const Color(0xFF808080),
      fontStyle: FontStyle.italic,
    );
    final puncStyle = base.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
    );

    // Improved regex: No spaces or backspaces around true/false/null, better string matching
    final re = RegExp(
      r'("(\\.|[^"])*")|(-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)|(true|false|null)|([\{\}\[\]:,])',
      multiLine: true,
    );

    final spans = <InlineSpan>[];
    var idx = 0;

    for (final m in re.allMatches(jsonText)) {
      if (m.start > idx) {
        spans.add(
          TextSpan(text: jsonText.substring(idx, m.start), style: base),
        );
      }

      final token = m.group(0)!;
      var style = base;

      if (token.startsWith('"')) {
        // Efficiently peek ahead for ':' to identify keys
        bool isKey = false;
        for (int i = m.end; i < jsonText.length; i++) {
          final char = jsonText[i];
          if (char == ' ' || char == '\n' || char == '\r' || char == '\t') {
            continue;
          }
          if (char == ':') isKey = true;
          break;
        }
        style = isKey ? keyStyle : strStyle;
      } else if (token == 'true' || token == 'false') {
        style = boolStyle;
      } else if (token == 'null') {
        style = nullStyle;
      } else if (_isNumberToken(token)) {
        style = numStyle;
      } else if ('{}[]:,'.contains(token)) {
        style = puncStyle;
      }

      spans.add(TextSpan(text: token, style: style));
      idx = m.end;
    }

    if (idx < jsonText.length) {
      spans.add(TextSpan(text: jsonText.substring(idx), style: base));
    }

    return spans;
  }

  bool _isNumberToken(String s) =>
      RegExp(r'^-?\d+(\.\d+)?([eE][+-]?\d+)?$').hasMatch(s);
}

String _prettyText(dynamic v) {
  if (v == null) return '';
  if (v is String) {
    final t = v.trim();
    if (_looksLikeJson(t)) {
      try {
        final decoded = json.decode(t);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      } catch (_) {
        // Fallback for truncated/invalid JSON
        return _basicFormatJson(t);
      }
    }
    return v;
  }
  if (v is Map || v is List) {
    try {
      return const JsonEncoder.withIndent('  ').convert(v);
    } catch (_) {
      return v.toString();
    }
  }
  return v.toString();
}

/// A very simple formatter for non-perfect JSON (truncated/invalid)
String _basicFormatJson(String s) {
  final out = StringBuffer();
  var indent = 0;
  var inString = false;
  var escaped = false;

  for (var i = 0; i < s.length; i++) {
    final c = s[i];

    if (escaped) {
      out.write(c);
      escaped = false;
      continue;
    }

    if (c == '"') {
      inString = !inString;
      out.write(c);
      continue;
    }

    if (inString) {
      if (c == '\\') escaped = true;
      out.write(c);
      continue;
    }

    if (c == '{' || c == '[') {
      out.write(c);
      out.write('\n');
      indent++;
      out.write('  ' * indent);
    } else if (c == '}' || c == ']') {
      out.write('\n');
      indent = (indent - 1).clamp(0, 99);
      out.write('  ' * indent);
      out.write(c);
    } else if (c == ',') {
      out.write(c);
      out.write('\n');
      out.write('  ' * indent);
    } else if (c == ':') {
      out.write(c);
      out.write(' ');
    } else if (c != ' ' && c != '\n' && c != '\r' && c != '\t') {
      out.write(c);
    }
  }
  return out.toString();
}

bool _looksLikeJson(String s) {
  final t = s.trim();
  if (t.isEmpty) return false;
  // More inclusive check for truncated JSON
  return t.startsWith('{') || t.startsWith('[');
}

/* -------------------------------------------------------------------------- */
/*                                 cURL builder                               */
/* -------------------------------------------------------------------------- */

String _asCurl(DevtoolsNetEntry e) {
  final b = StringBuffer()
    ..write('curl -X ${e.method.toUpperCase()} ')
    ..write('"${e.uri}"');

  e.requestHeaders.forEach((k, v) {
    if (v == null) return;
    b.write(' -H "$k: ${v.toString().replaceAll('"', '"')}"');
  });

  final hasBodyMethod = {
    'POST',
    'PUT',
    'PATCH',
    'DELETE',
  }.contains(e.method.toUpperCase());

  if (hasBodyMethod && e.requestBody != null) {
    final bodyText = _prettyText(e.requestBody).replaceAll('"', '"');
    if (bodyText.isNotEmpty) {
      b.write(' --data "$bodyText"');
    }
  }

  return b.toString();
}

/* -------------------------------------------------------------------------- */
/*                                Small helpers                               */
/* -------------------------------------------------------------------------- */

class _CompactMenu<T> extends StatelessWidget {
  const _CompactMenu({
    required this.tooltip,
    required this.icon,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onSelected,
  });

  final String tooltip;
  final Widget icon;
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => MenuAnchor(
    builder: (context, controller, child) => IconButton(
      tooltip: tooltip,
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
      icon: icon,
    ),
    menuChildren: items
        .map(
          (v) => MenuItemButton(
            onPressed: () => onSelected(v),
            child: Row(
              children: [
                Expanded(child: Text(labelBuilder(v))),
                if (v == value) const Icon(Icons.check, size: 18),
              ],
            ),
          ),
        )
        .toList(),
  );
}
