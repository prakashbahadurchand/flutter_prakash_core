/// ---------------------------------------------------------------------------
/// 🏢 Company   : Softix Info Pvt. Ltd.
/// 📅 Created   : Sunday, March 22, 2026 • 01:13 PM
/// ---------------------------------------------------------------------------
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DevtoolsAppDataStorageTabView extends StatefulWidget {
  const DevtoolsAppDataStorageTabView({super.key});

  @override
  State<DevtoolsAppDataStorageTabView> createState() =>
      _DevtoolsAppDataStorageTabViewState();
}

class _DevtoolsAppDataStorageTabViewState
    extends State<DevtoolsAppDataStorageTabView> {
  bool _loading = true;
  String? _error;

  bool _showHidden = false;
  bool _sortBySize = true;

  final List<_RootDir> _roots = [];

  // Cache: path -> size bytes (recursive computed)
  final Map<String, int> _sizeCache = {};

  @override
  void initState() {
    super.initState();
    unawaited(_loadRoots());
  }

  Future<void> _loadRoots() async {
    setState(() {
      _loading = true;
      _error = null;
      _roots.clear();
      _sizeCache.clear();
    });

    try {
      final docs = await getApplicationDocumentsDirectory();
      final support = await getApplicationSupportDirectory();
      final temp = await getTemporaryDirectory();

      _roots.addAll([
        _RootDir('Documents', docs),
        _RootDir('Support', support),
        _RootDir('Temp', temp),
      ]);

      if (!kIsWeb && Platform.isAndroid) {
        final ext = await getExternalStorageDirectory();
        if (ext != null) _roots.add(_RootDir('External (app)', ext));
      }
    } catch (e) {
      _error = e.toString();
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Failed: $_error'));

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _Toolbar(
            showHidden: _showHidden,
            sortBySize: _sortBySize,
            onReload: _loadRoots,
            onToggleHidden: (v) => setState(() => _showHidden = v),
            onToggleSort: (v) => setState(() => _sortBySize = v),
            onHelp: () => _snack(
              context,
              'Tip: Tap folder to expand. Σ = compute total size (recursive). Long-press to copy path.',
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _roots.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final r = _roots[i];
                return _RootTile(
                  title: r.label,
                  path: r.dir.path,
                  child: _FsNodeTile(
                    node: _FsNode.root(r.label, r.dir),
                    showHidden: _showHidden,
                    sortBySize: _sortBySize,
                    sizeCache: _sizeCache,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.showHidden,
    required this.sortBySize,
    required this.onReload,
    required this.onToggleHidden,
    required this.onToggleSort,
    required this.onHelp,
  });

  final bool showHidden;
  final bool sortBySize;
  final VoidCallback onReload;
  final ValueChanged<bool> onToggleHidden;
  final ValueChanged<bool> onToggleSort;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onReload,
        icon: const Icon(Icons.refresh),
      ),
      const SizedBox(width: 6),
      FilterChip(
        visualDensity: VisualDensity.compact,
        label: const Text('Hidden'),
        selected: showHidden,
        onSelected: onToggleHidden,
      ),
      const SizedBox(width: 6),
      FilterChip(
        visualDensity: VisualDensity.compact,
        label: const Text('By size'),
        selected: sortBySize,
        onSelected: onToggleSort,
      ),
      const Spacer(),
      IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onHelp,
        icon: const Icon(Icons.info_outline),
      ),
    ],
  );
}

class _RootDir {
  _RootDir(this.label, this.dir);
  final String label;
  final Directory dir;
}

class _FsNode {
  _FsNode({
    required this.name,
    required this.path,
    required this.isDir,
    required this.depth,
    this.directBytes,
    this.totalBytes,
    this.loaded = false,
  });

  factory _FsNode.root(String label, Directory dir) =>
      _FsNode(name: label, path: dir.path, isDir: true, depth: 0);

  final String name;
  final String path;
  final bool isDir;
  final int depth;

  int? directBytes; // immediate files only
  int? totalBytes; // recursive (Σ)
  List<_FsNode>? children;
  bool loaded;
}

class _RootTile extends StatelessWidget {
  const _RootTile({
    required this.title,
    required this.path,
    required this.child,
  });

  final String title;
  final String path;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 2,
          ),
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(path, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.copy),
            onPressed: () {
              unawaited(Clipboard.setData(ClipboardData(text: path)));
              _snack(context, 'Copied path');
            },
          ),
        ),
        const Divider(height: 1),
        child,
      ],
    ),
  );
}

class _FsNodeTile extends StatefulWidget {
  const _FsNodeTile({
    required this.node,
    required this.showHidden,
    required this.sortBySize,
    required this.sizeCache,
  });

  final _FsNode node;
  final bool showHidden;
  final bool sortBySize;
  final Map<String, int> sizeCache;

  @override
  State<_FsNodeTile> createState() => _FsNodeTileState();
}

class _FsNodeTileState extends State<_FsNodeTile> {
  bool _expanded = false;
  bool _loading = false;
  String? _error;

  // for Σ computation
  bool _computing = false;
  double _progress = 0.0;
  int _visitedFiles = 0;
  int _visitedDirs = 0;
  bool _cancel = false;

  Future<void> _toggle() async {
    if (_expanded) {
      setState(() => _expanded = false);
      return;
    }

    setState(() => _expanded = true);

    if (!widget.node.loaded) {
      await _loadChildren();
    }
  }

  Future<void> _loadChildren() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final dir = Directory(widget.node.path);
      final entities = await dir.list(followLinks: false).toList();

      final kids = <_FsNode>[];
      var direct = 0;

      for (final e in entities) {
        final name = e.path.split(Platform.pathSeparator).last;
        if (!widget.showHidden && name.startsWith('.')) continue;

        if (e is Directory) {
          final cached = widget.sizeCache[e.path];
          kids.add(
            _FsNode(
              name: name,
              path: e.path,
              isDir: true,
              depth: widget.node.depth + 1,
              totalBytes: cached, // may be known from cache
            ),
          );
        } else if (e is File) {
          final len = await _safeLen(e);
          direct += len;
          kids.add(
            _FsNode(
              name: name,
              path: e.path,
              isDir: false,
              depth: widget.node.depth + 1,
              directBytes: len,
              totalBytes: len,
              loaded: true,
            ),
          );
        }
      }

      _sort(kids, widget.sortBySize);

      widget.node.directBytes = direct;
      widget.node.children = kids;
      widget.node.loaded = true;

      // if we already computed total before
      final cached = widget.sizeCache[widget.node.path];
      if (cached != null) widget.node.totalBytes = cached;
    } catch (e) {
      _error = e.toString();
    }

    if (!mounted) return;
    setState(() => _loading = false);
  }

  void _sort(List<_FsNode> kids, bool sortBySize) {
    kids.sort((a, b) {
      if (a.isDir != b.isDir) return a.isDir ? -1 : 1;

      if (sortBySize) {
        final sa = a.totalBytes ?? a.directBytes ?? -1;
        final sb = b.totalBytes ?? b.directBytes ?? -1;
        if (sa == -1 && sb != -1) return 1;
        if (sb == -1 && sa != -1) return -1;
        final cmp = sb.compareTo(sa);
        if (cmp != 0) return cmp;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  Future<int> _safeLen(File f) async {
    try {
      return await f.length();
    } catch (_) {
      return 0;
    }
  }

  Future<void> _computeTotalSize() async {
    if (_computing) return;

    setState(() {
      _computing = true;
      _cancel = false;
      _progress = 0.0;
      _visitedFiles = 0;
      _visitedDirs = 0;
      _error = null;
    });

    var total = 0;

    try {
      final root = Directory(widget.node.path);

      // Two-phase approach: count entries quickly-ish (best effort),
      // then compute with progress. If counting fails, progress stays indeterminate.
      int? estimatedTotal;
      try {
        var count = 0;
        await for (final _ in root.list(recursive: true, followLinks: false)) {
          count++;
          if (count > 20000) break; // avoid insane counting overhead
        }
        estimatedTotal = count == 0 ? null : count;
      } catch (_) {
        estimatedTotal = null;
      }

      var processed = 0;

      await for (final e in root.list(recursive: true, followLinks: false)) {
        if (_cancel) break;

        processed++;
        if (e is Directory) {
          _visitedDirs++;
        }

        if (e is File) {
          final name = e.path.split(Platform.pathSeparator).last;
          if (!widget.showHidden && name.startsWith('.')) continue;
          total += await _safeLen(e);
          _visitedFiles++;
        }

        // update UI occasionally
        if (processed % 60 == 0) {
          if (!mounted) break;
          setState(() {
            if (estimatedTotal != null) {
              _progress = (processed / estimatedTotal).clamp(0.0, 1.0);
            } else {
              _progress = 0.0; // indeterminate mode
            }
          });
        }
      }
    } catch (e) {
      _error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      _computing = false;
      if (!_cancel && _error == null) {
        widget.node.totalBytes = total;
        widget.sizeCache[widget.node.path] = total;
      }
    });

    if (!_cancel && _error == null) {
      _snack(context, 'Total size: ${_formatBytes(total)}');
    }
  }

  List<_FsNode> _topHeaviestChildren(_FsNode n, {int take = 6}) {
    final kids = n.children ?? const <_FsNode>[];
    final list = kids.toList();

    int sizeOf(_FsNode x) => x.totalBytes ?? x.directBytes ?? 0;

    list.sort((a, b) => sizeOf(b).compareTo(sizeOf(a)));
    return list.where((e) => sizeOf(e) > 0).take(take).toList();
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.node;
    final theme = Theme.of(context);

    final indent = (n.depth * 10).toDouble(); // tighter than before

    final icon = n.isDir
        ? (_expanded ? Icons.folder_open : Icons.folder)
        : Icons.insert_drive_file;

    final directText = n.directBytes == null
        ? '—'
        : _formatBytes(n.directBytes!);
    final totalText = n.totalBytes == null ? '—' : _formatBytes(n.totalBytes!);

    final sizeLabel = n.isDir ? 'D:$directText  Σ:$totalText' : totalText;

    return Column(
      children: [
        ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.only(left: 10 + indent, right: 6),
          leading: Icon(icon, size: 18),
          title: Text(n.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            sizeLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (n.isDir)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.functions), // Σ
                  onPressed: _computing ? null : _computeTotalSize,
                ),
              if (n.isDir)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: _loading ? null : _toggle,
                ),
              PopupMenuButton<_NodeAction>(
                tooltip: '',
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _NodeAction.copyPath,
                    child: Text('Copy path'),
                  ),
                  PopupMenuItem(
                    value: _NodeAction.refreshNode,
                    child: Text('Reload folder'),
                  ),
                ],
                onSelected: (a) async {
                  if (a == _NodeAction.copyPath) {
                    unawaited(Clipboard.setData(ClipboardData(text: n.path)));
                    _snack(context, 'Copied path');
                  }
                  if (a == _NodeAction.refreshNode) {
                    n
                      ..loaded = false
                      ..children = null
                      ..directBytes = null;
                    if (mounted) setState(() {});
                    if (_expanded) await _loadChildren();
                  }
                },
              ),
            ],
          ),
          onTap: n.isDir ? _toggle : null,
          onLongPress: () {
            unawaited(Clipboard.setData(ClipboardData(text: n.path)));
            _snack(context, 'Copied path');
          },
        ),

        if (_loading) const LinearProgressIndicator(minHeight: 2),

        if (_computing)
          Padding(
            padding: EdgeInsets.only(left: 10 + indent, right: 10, bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Analyzing…', style: theme.textTheme.bodySmall),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() => _cancel = true),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                if (_progress > 0)
                  LinearProgressIndicator(value: _progress)
                else
                  const LinearProgressIndicator(),
                const SizedBox(height: 4),
                Text(
                  'Files: $_visitedFiles  Dirs: $_visitedDirs',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

        if (_error != null)
          Padding(
            padding: EdgeInsets.only(left: 10 + indent, right: 10, bottom: 6),
            child: Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),

        if (_expanded) _children(n),
      ],
    );
  }

  Widget _children(_FsNode n) {
    final kids = n.children;
    if (kids == null || kids.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Align(alignment: Alignment.centerLeft, child: Text('Empty')),
      );
    }

    final heavy = _topHeaviestChildren(n);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        children: [
          if (heavy.isNotEmpty) _HeaviestStrip(items: heavy),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kids.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = kids[i];
              if (c.isDir) {
                return _FsNodeTile(
                  node: c,
                  showHidden: widget.showHidden,
                  sortBySize: widget.sortBySize,
                  sizeCache: widget.sizeCache,
                );
              }

              final bytes = c.totalBytes ?? c.directBytes ?? 0;

              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.only(
                  left: 10 + (c.depth * 10).toDouble(),
                  right: 10,
                ),
                leading: const Icon(Icons.insert_drive_file, size: 16),
                title: Text(
                  c.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  _formatBytes(bytes),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onLongPress: () {
                  unawaited(Clipboard.setData(ClipboardData(text: c.path)));
                  _snack(context, 'Copied path');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

enum _NodeAction { copyPath, refreshNode }

class _HeaviestStrip extends StatelessWidget {
  const _HeaviestStrip({required this.items});
  final List<_FsNode> items;

  @override
  Widget build(BuildContext context) {
    int sizeOf(_FsNode x) => x.totalBytes ?? x.directBytes ?? 0;
    final max = items.map(sizeOf).fold<int>(0, (a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Largest here', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          ...items.map((e) {
            final s = sizeOf(e);
            final ratio = max == 0 ? 0.0 : (s / max).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      e.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatBytes(s),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

String _formatBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var v = bytes.toDouble();
  var i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  final fixed = (i == 0) ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
  return '$fixed ${units[i]}';
}

void _snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
  );
}
