import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageSource { sharedPrefs, secureStorage }

class StorageItem {
  StorageItem({required this.key, required this.value, required this.source});
  final String key;
  final Object? value;
  final StorageSource source;
}

class DevtoolsPreferencesTabView extends StatefulWidget {
  const DevtoolsPreferencesTabView({super.key});

  @override
  State<DevtoolsPreferencesTabView> createState() =>
      _DevtoolsPreferencesTabViewState();
}

class _DevtoolsPreferencesTabViewState
    extends State<DevtoolsPreferencesTabView> {
  SharedPreferences? _prefs;
  final _secureStorage = const FlutterSecureStorage();

  List<StorageItem> _allItems = [];
  String _q = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    // 1. Load SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final spKeys = prefs.getKeys().toList()..sort();

    // 2. Load Secure Storage
    var secureData = <String, String>{};
    try {
      secureData = await _secureStorage.readAll();
    } catch (e) {
      debugPrint('Failed to read secure storage: $e');
    }
    final ssKeys = secureData.keys.toList()..sort();

    final items = <StorageItem>[];

    for (final k in spKeys) {
      items.add(
        StorageItem(
          key: k,
          value: prefs.get(k),
          source: StorageSource.sharedPrefs,
        ),
      );
    }

    for (final k in ssKeys) {
      items.add(
        StorageItem(
          key: k,
          value: secureData[k],
          source: StorageSource.secureStorage,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _allItems = items;
      _loading = false;
    });
  }

  List<StorageItem> get _filteredItems {
    final q = _q.trim().toLowerCase();
    if (q.isEmpty) return _allItems;
    return _allItems.where((i) => i.key.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _filteredItems;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search keys…',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _q = v),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
              IconButton(
                onPressed: _prefs == null
                    ? null
                    : () async {
                        final ok = await _confirm(
                          context,
                          title: 'Clear all preferences?',
                          message:
                              'This will remove all SharedPreferences AND Secure Storage keys for this app.',
                          confirmText: 'Clear All',
                        );
                        if (!ok) return;

                        await _prefs!.clear();
                        await _secureStorage.deleteAll();

                        await _load();
                        if (!context.mounted) return;
                        _snack(
                          context,
                          'Cleared all preferences & secure storage',
                        );
                      },
                icon: const Icon(Icons.delete_sweep),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ExpandableAddPrefCard(
            enabled: _prefs != null,
            onAdd: (source, k, type, raw) async {
              try {
                if (source == StorageSource.secureStorage) {
                  await _secureStorage.write(key: k, value: raw);
                } else {
                  await _setTyped(_prefs!, k, type, raw);
                }
              } catch (e) {
                if (!context.mounted) return;
                _snack(context, 'Add failed: $e');
                return;
              }

              await _load();
              if (!context.mounted) return;
              _snack(context, 'Saved "$k"');
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                  ? const Center(child: Text('No keys found'))
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: theme.dividerColor),
                      itemBuilder: (context, i) {
                        final item = items[i];
                        final isSecure =
                            item.source == StorageSource.secureStorage;

                        return ListTile(
                          title: Row(
                            children: [
                              Icon(
                                isSecure ? Icons.lock : Icons.storage,
                                size: 16,
                                color: isSecure
                                    ? Colors.green
                                    : Colors.blueGrey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.key,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            _oneLineSummary(item.value),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: _TypeChip(value: item.value),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              unawaited(
                                Clipboard.setData(
                                  ClipboardData(text: item.key),
                                ),
                              );
                              _snack(context, 'Copied key');
                            },
                          ),
                          onTap: _prefs == null
                              ? null
                              : () => _openEditorSheet(context, item: item),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditorSheet(
    BuildContext context, {
    required StorageItem item,
  }) async {
    final result = await showModalBottomSheet<_PrefEditResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PrefEditorSheet(item: item),
    );

    if (result == null) return;

    if (result.action == _PrefEditAction.delete) {
      if (item.source == StorageSource.secureStorage) {
        await _secureStorage.delete(key: item.key);
      } else {
        await _prefs!.remove(item.key);
      }

      await _load();
      if (!context.mounted) return;
      _snack(context, 'Deleted "${item.key}"');
      return;
    }

    if (result.action == _PrefEditAction.save) {
      try {
        if (item.source == StorageSource.secureStorage) {
          await _secureStorage.write(key: item.key, value: result.rawValue);
        } else {
          final inferred = _inferType(item.value);
          await _setTyped(_prefs!, item.key, inferred, result.rawValue);
        }
      } catch (e) {
        if (!context.mounted) return;
        _snack(context, 'Save failed: $e');
        return;
      }

      await _load();
      if (!context.mounted) return;
      _snack(context, 'Saved "${item.key}"');
    }
  }
}

/* ------------------------- UI components & helpers ------------------------- */

enum PrefValueType { string, bool, int, double, stringList }

PrefValueType _inferType(Object? v) {
  if (v is bool) return PrefValueType.bool;
  if (v is int) return PrefValueType.int;
  if (v is double) return PrefValueType.double;
  if (v is List<String>) return PrefValueType.stringList;
  return PrefValueType.string;
}

Future<void> _setTyped(
  SharedPreferences prefs,
  String key,
  PrefValueType type,
  String raw,
) async {
  switch (type) {
    case PrefValueType.string:
      await prefs.setString(key, raw);
      break;
    case PrefValueType.bool:
      final b = _parseBool(raw);
      if (b == null) throw const FormatException('Invalid bool');
      await prefs.setBool(key, b);
      break;
    case PrefValueType.int:
      await prefs.setInt(key, int.parse(raw.trim()));
      break;
    case PrefValueType.double:
      await prefs.setDouble(key, double.parse(raw.trim()));
      break;
    case PrefValueType.stringList:
      await prefs.setStringList(key, _parseStringList(raw));
      break;
  }
}

bool? _parseBool(String raw) {
  final t = raw.trim().toLowerCase();
  if (t == 'true' || t == '1' || t == 'yes' || t == 'y') return true;
  if (t == 'false' || t == '0' || t == 'no' || t == 'n') return false;
  return null;
}

List<String> _parseStringList(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return <String>[];
  if (t.startsWith('[') && t.endsWith(']')) {
    final decoded = json.decode(t);
    if (decoded is List) return decoded.map((e) => e.toString()).toList();
  }
  return t
      .split(RegExp(r'[\n,]'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

String _oneLineSummary(Object? v) {
  if (v == null) return 'null';
  if (v is String) {
    final t = v.replaceAll('\n', ' ↵ ');
    return t.length > 80 ? '${t.substring(0, 80)}…' : t;
  }
  if (v is List) return '[${v.length} items]';
  return v.toString();
}

String _pretty(String raw) {
  final t = raw.trim();
  if ((t.startsWith('{') && t.endsWith('}')) ||
      (t.startsWith('[') && t.endsWith(']'))) {
    try {
      final decoded = json.decode(t);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {}
  }
  return raw;
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
  );
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
}) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return res ?? false;
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.value});
  final Object? value;

  @override
  Widget build(BuildContext context) {
    final type = value == null ? 'null' : value.runtimeType.toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(type, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _AddPrefCard extends StatefulWidget {
  const _AddPrefCard({required this.enabled, required this.onAdd});
  final bool enabled;
  final Future<void> Function(
    StorageSource source,
    String key,
    PrefValueType type,
    String raw,
  )
  onAdd;

  @override
  State<_AddPrefCard> createState() => _AddPrefCardState();
}

class _AddPrefCardState extends State<_AddPrefCard> {
  final _keyCtrl = TextEditingController();
  final _valCtrl = TextEditingController();

  StorageSource _source = StorageSource.sharedPrefs;
  PrefValueType _type = PrefValueType.string;

  @override
  void dispose() {
    _keyCtrl.dispose();
    _valCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSecure = _source == StorageSource.secureStorage;

    return Column(
      children: [
        Row(
          children: [
            SegmentedButton<StorageSource>(
              segments: const [
                ButtonSegment(
                  value: StorageSource.sharedPrefs,
                  label: Text('Shared'),
                  icon: Icon(Icons.storage, size: 16),
                ),
                ButtonSegment(
                  value: StorageSource.secureStorage,
                  label: Text('Secure'),
                  icon: Icon(Icons.lock, size: 16),
                ),
              ],
              selected: {_source},
              onSelectionChanged: widget.enabled
                  ? (Set<StorageSource> newSelection) {
                      setState(() {
                        _source = newSelection.first;
                        if (_source == StorageSource.secureStorage) {
                          _type = PrefValueType.string;
                        }
                      });
                    }
                  : null,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
            const Spacer(),
            DropdownButton<PrefValueType>(
              value: _type,
              // Secure storage only supports strings natively
              onChanged: (widget.enabled && !isSecure)
                  ? (v) => setState(() => _type = v!)
                  : null,
              items: const [
                DropdownMenuItem(
                  value: PrefValueType.string,
                  child: Text('String'),
                ),
                DropdownMenuItem(
                  value: PrefValueType.bool,
                  child: Text('Bool'),
                ),
                DropdownMenuItem(value: PrefValueType.int, child: Text('Int')),
                DropdownMenuItem(
                  value: PrefValueType.double,
                  child: Text('Double'),
                ),
                DropdownMenuItem(
                  value: PrefValueType.stringList,
                  child: Text('StringList'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _keyCtrl,
          enabled: widget.enabled,
          decoration: const InputDecoration(
            labelText: 'Key',
            isDense: true,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _valCtrl,
          enabled: widget.enabled,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Value',
            hintText: isSecure
                ? 'Secure storage values must be strings'
                : 'StringList: ["a","b"] or comma/newline separated',
            border: const OutlineInputBorder(),
          ),
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: !widget.enabled
                ? null
                : () async {
                    final key = _keyCtrl.text.trim();
                    if (key.isEmpty) {
                      _snack(context, 'Key is required');
                      return;
                    }
                    await widget.onAdd(_source, key, _type, _valCtrl.text);
                    _keyCtrl.clear();
                    _valCtrl.clear();
                  },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ),
      ],
    );
  }
}

enum _PrefEditAction { save, delete }

class _PrefEditResult {
  _PrefEditResult(this.action, this.rawValue);
  final _PrefEditAction action;
  final String rawValue;
}

class _PrefEditorSheet extends StatefulWidget {
  const _PrefEditorSheet({required this.item});

  final StorageItem item;

  @override
  State<_PrefEditorSheet> createState() => _PrefEditorSheetState();
}

class _PrefEditorSheetState extends State<_PrefEditorSheet> {
  late final TextEditingController _ctrl;
  bool _prettyJson = true;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.item.value?.toString() ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.item.value == null
        ? 'null'
        : widget.item.value.runtimeType.toString();

    final isSecure = widget.item.source == StorageSource.secureStorage;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                isSecure ? Icons.lock : Icons.storage,
                color: isSecure ? Colors.green : Colors.blueGrey,
              ),
              title: Text(
                widget.item.key,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${isSecure ? 'Secure Storage' : 'Shared Preferences'} • Type: $type',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  unawaited(
                    Clipboard.setData(ClipboardData(text: widget.item.key)),
                  );
                  _snack(context, 'Copied key');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Pretty JSON'),
                    selected: _prettyJson,
                    onSelected: (v) => setState(() => _prettyJson = v),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      unawaited(
                        Clipboard.setData(ClipboardData(text: _ctrl.text)),
                      );
                      _snack(context, 'Copied value');
                    },
                    icon: const Icon(Icons.copy_all),
                    label: const Text('Copy value'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _ctrl,
                maxLines: 10,
                minLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Value',
                ),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(
                        context,
                        _PrefEditResult(_PrefEditAction.delete, ''),
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        final raw = _prettyJson
                            ? _pretty(_ctrl.text)
                            : _ctrl.text;
                        Navigator.pop(
                          context,
                          _PrefEditResult(_PrefEditAction.save, raw),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableAddPrefCard extends StatefulWidget {
  const _ExpandableAddPrefCard({required this.enabled, required this.onAdd});

  final bool enabled;
  final Future<void> Function(
    StorageSource source,
    String key,
    PrefValueType type,
    String raw,
  )
  onAdd;

  @override
  State<_ExpandableAddPrefCard> createState() => _ExpandableAddPrefCardState();
}

class _ExpandableAddPrefCardState extends State<_ExpandableAddPrefCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        onExpansionChanged: (v) => setState(() => _expanded = v),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        leading: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        title: Text(
          'Add / overwrite',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          widget.enabled ? 'Tap to expand' : 'Loading…',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: [_AddPrefCard(enabled: widget.enabled, onAdd: widget.onAdd)],
      ),
    ),
  );
}
