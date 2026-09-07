import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gql/ast.dart' show OperationType;
import 'package:gql/language.dart' show printNode;
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';

/// A single captured GraphQL operation entry.
class DevtoolsGraphqlEntry {
  final String id;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String operationType;
  final String operationName;
  final String? query;
  final Map<String, dynamic> variables;
  final bool hasError;
  final String? errorMessage;
  final String? responseBody;
  final Duration? duration;
  final int? statusCode;

  const DevtoolsGraphqlEntry({
    required this.id,
    required this.startedAt,
    this.completedAt,
    required this.operationType,
    required this.operationName,
    this.query,
    this.variables = const {},
    this.hasError = false,
    this.errorMessage,
    this.responseBody,
    this.duration,
    this.statusCode,
  });

  DevtoolsGraphqlEntry copyWith({
    DateTime? completedAt,
    bool? hasError,
    String? errorMessage,
    String? responseBody,
    Duration? duration,
    int? statusCode,
  }) {
    return DevtoolsGraphqlEntry(
      id: id,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      operationType: operationType,
      operationName: operationName,
      query: query,
      variables: variables,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      responseBody: responseBody ?? this.responseBody,
      duration: duration ?? this.duration,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

/// Global controller holding captured GraphQL operations.
class DevtoolsGraphqlController extends ChangeNotifier {
  DevtoolsGraphqlController._();

  static final DevtoolsGraphqlController instance =
      DevtoolsGraphqlController._();

  final List<DevtoolsGraphqlEntry> _entries = [];
  List<DevtoolsGraphqlEntry> get entries => List.unmodifiable(_entries);

  int maxEntries = 250;
  bool paused = false;

  void clear() {
    _entries.clear();
    notifyListeners();
  }

  void setPaused(bool value) {
    paused = value;
    notifyListeners();
  }

  void add(DevtoolsGraphqlEntry entry) {
    if (paused) return;
    _entries.insert(0, entry);
    if (_entries.length > maxEntries) {
      _entries.removeRange(maxEntries, _entries.length);
    }
    notifyListeners();
  }

  void update(String id, DevtoolsGraphqlEntry entry) {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    _entries[idx] = entry;
    notifyListeners();
  }
}

/// A [Link] wrapper that captures GraphQL operations for the inspector.
///
/// Insert this link into your `graphql` client's link chain, typically just
/// before the terminating (HTTP/WS) link:
/// ```dart
/// final httpLink = HttpLink('https://your-api/graphql');
/// final logLink = DevtoolsGraphqlLink(controller: DevtoolsGraphqlController.instance);
/// final link = Link.from([logLink, httpLink]);
/// ```
class DevtoolsGraphqlLink extends Link {
  DevtoolsGraphqlLink({
    required this.controller,
    this.enabled = true,
    this.maxBodyChars = 25000,
  });

  final DevtoolsGraphqlController controller;
  final bool enabled;
  final int maxBodyChars;

  int _counter = 0;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    final incoming = forward ?? const PassthroughLink().request;
    if (!enabled) return incoming(request);

    final now = DateTime.now();
    final id = 'gql_${now.microsecondsSinceEpoch}_${_counter++}';

    final operation = request.operation;
    final operationTypeString = _operationTypeName(operation);
    final operationName = _resolveOperationName(operation, request);
    final queryString = _truncate(_safePrint(operation), maxBodyChars);

    controller.add(
      DevtoolsGraphqlEntry(
        id: id,
        startedAt: now,
        operationType: operationTypeString,
        operationName: operationName,
        query: queryString,
        variables: request.variables,
      ),
    );

    final stopwatch = Stopwatch()..start();

    return incoming(request)
        .map((response) {
          stopwatch.stop();
          final completedAt = DateTime.now();
          final hasError = response.errors?.isNotEmpty ?? false;
          final errorMessage = hasError ? response.errors!.first.message : null;
          final responseBody = _responseToJson(response);

          controller.update(
            id,
            DevtoolsGraphqlEntry(
              id: id,
              startedAt: now,
              completedAt: completedAt,
              operationType: operationTypeString,
              operationName: operationName,
              query: queryString,
              variables: request.variables,
              hasError: hasError,
              errorMessage: errorMessage,
              responseBody: _truncate(responseBody, maxBodyChars),
              duration: stopwatch.elapsed,
            ),
          );

          return response;
        })
        .handleError((Object error) {
          stopwatch.stop();
          controller.update(
            id,
            DevtoolsGraphqlEntry(
              id: id,
              startedAt: now,
              completedAt: DateTime.now(),
              operationType: operationTypeString,
              operationName: operationName,
              query: queryString,
              variables: request.variables,
              hasError: true,
              errorMessage: error.toString(),
              duration: stopwatch.elapsed,
            ),
          );
        });
  }

  static String _operationTypeName(Operation operation) {
    final type = operation.getOperationType();
    return switch (type) {
      OperationType.query => 'Query',
      OperationType.mutation => 'Mutation',
      OperationType.subscription => 'Subscription',
      null => 'Operation',
    };
  }

  static String _resolveOperationName(Operation operation, Request request) {
    final explicit = operation.operationName;
    if (explicit != null && explicit.isNotEmpty) return explicit;
    return _extractFromQuery(operation) ?? 'Anonymous';
  }

  static String? _extractFromQuery(Operation operation) {
    try {
      final text = _safePrint(operation);
      final firstLine = text.split('\n').first.trim();
      final match = RegExp(
        r'(?:query|mutation|subscription)\s+([A-Za-z_][A-Za-z0-9_]*)',
      ).firstMatch(firstLine);
      return match?.group(1);
    } catch (_) {
      return null;
    }
  }

  static String _safePrint(Operation operation) {
    try {
      return printNode(operation.document);
    } catch (_) {
      return operation.operationName ?? '';
    }
  }

  static String? _responseToJson(Response response) {
    try {
      final data = response.data;
      final errors = response.errors;
      if (data == null && (errors == null || errors.isEmpty)) return null;
      final map = <String, dynamic>{
        'data': ?data,
        if (errors != null && errors.isNotEmpty)
          'errors': errors
              .map(
                (e) => <String, dynamic>{
                  'message': e.message,
                  if (e.path != null) 'path': e.path,
                },
              )
              .toList(),
      };
      return const JsonEncoder.withIndent('  ').convert(map);
    } catch (_) {
      return null;
    }
  }

  static String _truncate(String? value, int maxChars) {
    if (value == null) return '';
    if (value.length <= maxChars) return value;
    return '${value.substring(0, maxChars)}\n… (truncated)';
  }
}

/// Internal passthrough used when no forward link is supplied.
class PassthroughLink extends Link {
  const PassthroughLink();

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (forward != null) return forward(request);
    return Stream.value(
      const Response(
        errors: [GraphQLError(message: 'No terminating link provided')],
        response: <String, dynamic>{},
      ),
    );
  }
}

/// GraphQL Inspector tab view.
class DevtoolsGraphqlInspectorTabView extends StatefulWidget {
  const DevtoolsGraphqlInspectorTabView({super.key});

  @override
  State<DevtoolsGraphqlInspectorTabView> createState() =>
      _DevtoolsGraphqlInspectorTabViewState();
}

class _DevtoolsGraphqlInspectorTabViewState
    extends State<DevtoolsGraphqlInspectorTabView> {
  final _controller = DevtoolsGraphqlController.instance;
  String _filter = '';
  bool _showErrorsOnly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _filter = v),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search queries, names…',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Errors only',
                onPressed: () =>
                    setState(() => _showErrorsOnly = !_showErrorsOnly),
                isSelected: _showErrorsOnly,
                icon: Icon(
                  _showErrorsOnly ? Icons.error : Icons.error_outline,
                  color: _showErrorsOnly ? colorScheme.error : null,
                ),
              ),
              IconButton(
                tooltip: _controller.paused ? 'Resume' : 'Pause',
                onPressed: () {
                  setState(() => _controller.setPaused(!_controller.paused));
                },
                icon: Icon(_controller.paused ? Icons.play_arrow : Icons.pause),
              ),
              IconButton(
                tooltip: 'Clear',
                onPressed: () => setState(_controller.clear),
                icon: const Icon(Icons.delete_sweep),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              final entries = _entries;
              if (entries.isEmpty) {
                return _EmptyState(
                  paused: _controller.paused,
                  onAdd: () => _showHowTo(context),
                );
              }
              return ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    _EntryTile(entry: entries[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  List<DevtoolsGraphqlEntry> get _entries {
    final entries = _controller.entries;
    final query = _filter.trim().toLowerCase();
    return entries.where((e) {
      final matchesFilter =
          query.isEmpty ||
          e.operationName.toLowerCase().contains(query) ||
          e.operationType.toLowerCase().contains(query) ||
          (e.query?.toLowerCase().contains(query) ?? false);
      final matchesError = !_showErrorsOnly || e.hasError;
      return matchesFilter && matchesError;
    }).toList();
  }

  static void _showHowTo(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Capturing GraphQL traffic',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Add the DevtoolsGraphqlLink to your graphql client link chain '
                'to start inspecting operations here:\n\n'
                'final link = Link.from([\n'
                '  DevtoolsGraphqlLink(\n'
                '    controller: DevtoolsGraphqlController.instance,\n'
                '  ),\n'
                '  httpLink,\n'
                ']);',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});
  final DevtoolsGraphqlEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = switch (entry.operationType) {
      'Query' => Colors.indigo,
      'Mutation' => Colors.deepOrange,
      _ => Colors.purple,
    };

    return ListTile(
      dense: true,
      onTap: () => _showDetails(context),
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: typeColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          entry.operationType,
          style: TextStyle(
            color: typeColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        entry.operationName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        _durationLabel(entry.duration),
        style: TextStyle(fontSize: 11, color: theme.hintColor),
      ),
      trailing: entry.hasError
          ? const Icon(Icons.error_outline, color: Colors.red, size: 18)
          : const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 18,
            ),
    );
  }

  static String _durationLabel(Duration? d) {
    if (d == null) return 'pending…';
    return '${d.inMilliseconds} ms';
  }

  void _showDetails(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) =>
              _EntryDetails(entry: entry, scrollController: scrollController),
        ),
      ),
    );
  }
}

class _EntryDetails extends StatelessWidget {
  const _EntryDetails({required this.entry, required this.scrollController});
  final DevtoolsGraphqlEntry entry;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = switch (entry.operationType) {
      'Query' => Colors.indigo,
      'Mutation' => Colors.deepOrange,
      _ => Colors.purple,
    };

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                entry.operationType,
                style: TextStyle(color: typeColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                entry.operationName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Copy entry',
              onPressed: () => _copy(),
              icon: const Icon(Icons.copy, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Started ${entry.startedAt.toIso8601String()}'
          '${entry.duration != null ? ' · ${entry.duration!.inMilliseconds} ms' : ''}'
          '${entry.hasError ? ' · ERROR' : ''}',
          style: TextStyle(fontSize: 12, color: theme.hintColor),
        ),
        if (entry.hasError) ...[
          const SizedBox(height: 8),
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                entry.errorMessage ?? 'Operation failed',
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          ),
        ],
        if (entry.query != null && entry.query!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SectionHeader(title: 'Query', onCopy: () => _copyText(entry.query!)),
          _CodeBlock(text: entry.query!),
        ],
        if (entry.variables.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SectionHeader(
            title: 'Variables',
            onCopy: () => _copyText(_pretty(entry.variables)),
          ),
          _CodeBlock(text: _pretty(entry.variables)),
        ],
        if (entry.responseBody != null && entry.responseBody!.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SectionHeader(
            title: 'Response',
            onCopy: () => _copyText(entry.responseBody!),
          ),
          _CodeBlock(text: entry.responseBody!),
        ],
      ],
    );
  }

  String _pretty(Object? value) {
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  void _copyText(String text) {
    unawaited(Clipboard.setData(ClipboardData(text: text)));
  }

  void _copy() {
    _copyText('''
${entry.operationType} ${entry.operationName}
Query:
${entry.query ?? ''}

Variables:
${_pretty(entry.variables)}

Response:
${entry.responseBody ?? ''}
''');
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onCopy});
  final String title;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const Spacer(),
        if (onCopy != null)
          TextButton.icon(
            onPressed: onCopy,
            icon: const Icon(Icons.copy, size: 14),
            label: const Text('Copy', style: TextStyle(fontSize: 11)),
          ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 320),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: SingleChildScrollView(
        child: SelectableText(
          text,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.paused, required this.onAdd});
  final bool paused;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.graphic_eq, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              paused ? 'GraphQL capture paused' : 'No GraphQL operations yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: paused ? null : onAdd,
              child: const Text('Connect the GraphQL link'),
            ),
          ],
        ),
      ),
    );
  }
}
