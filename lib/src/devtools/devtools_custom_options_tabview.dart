import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// A single configurable custom option (feature flag or toggle).
class DevtoolsCustomOption {
  final String key;
  final String label;
  final String description;
  final bool defaultValue;
  final String? group;

  const DevtoolsCustomOption({
    required this.key,
    required this.label,
    this.description = '',
    this.defaultValue = false,
    this.group,
  });
}

/// Simple in-memory registry of custom options registered by the app.
///
/// Apps can register feature flags via [DevtoolsCustomOptionsStore.register]
/// during bootstrap. The store persists the active toggles to
/// [SharedPreferences] under the `key` for each option, so a debug session
/// keeps its overrides between launches.
class DevtoolsCustomOptionsStore {
  DevtoolsCustomOptionsStore._();

  static final DevtoolsCustomOptionsStore instance =
      DevtoolsCustomOptionsStore._();

  final List<DevtoolsCustomOption> _options = [];
  final Map<String, bool> _overrides = {};

  /// The registered option list. Unmodifiable.
  List<DevtoolsCustomOption> get options => List.unmodifiable(_options);

  /// Whether the store already loaded persisted values.
  bool loaded = false;

  /// Registers or updates [option]. Duplicates (by key) are overwritten.
  void register(DevtoolsCustomOption option) {
    final idx = _options.indexWhere((o) => o.key == option.key);
    if (idx == -1) {
      _options.add(option);
    } else {
      _options[idx] = option;
    }
  }

  /// Registers a batch of options.
  void registerAll(Iterable<DevtoolsCustomOption> options) {
    for (final o in options) {
      register(o);
    }
  }

  /// Removes an option by key. Returns true if it was removed.
  bool unregister(String key) {
    final before = _options.length;
    _options.removeWhere((o) => o.key == key);
    return _options.length != before;
  }

  /// Clears all registered options and overrides from the store.
  void clear() {
    _options.clear();
    _overrides.clear();
    loaded = false;
  }

  /// Loads persisted overrides from [SharedPreferences].
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final option in _options) {
      final persisted = prefs.getBool(_prefKey(option.key));
      if (persisted != null) {
        _overrides[option.key] = persisted;
      }
    }
    loaded = true;
  }

  /// Reads the effective value for [key] — override if set, otherwise the
  /// option's default, otherwise `false`.
  bool valueOf(String key) {
    final overridden = _overrides[key];
    if (overridden != null) return overridden;
    final option = _options.where((o) => o.key == key).firstOrNull;
    return option?.defaultValue ?? false;
  }

  /// Reads the effective value for [option].
  bool isEnabled(DevtoolsCustomOption option) => valueOf(option.key);

  /// Sets an override for [key] and persists it.
  Future<void> setOverride(String key, bool value) async {
    _overrides[key] = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey(key), value);
  }

  /// Resets all overrides (clears persisted values).
  Future<void> resetAll() async {
    _overrides.clear();
    final prefs = await SharedPreferences.getInstance();
    for (final option in _options) {
      await prefs.remove(_prefKey(option.key));
    }
  }

  static String _prefKey(String key) => 'devtools_option_$key';
}

/// Custom Options tab view — feature flags and environment toggles.
class DevtoolsCustomOptionsTabView extends StatefulWidget {
  const DevtoolsCustomOptionsTabView({super.key, this.title = 'Options'});

  final String title;

  @override
  State<DevtoolsCustomOptionsTabView> createState() =>
      _DevtoolsCustomOptionsTabViewState();
}

class _DevtoolsCustomOptionsTabViewState
    extends State<DevtoolsCustomOptionsTabView> {
  final _store = DevtoolsCustomOptionsStore.instance;

  @override
  void initState() {
    super.initState();
    if (!_store.loaded) {
      unawaited(
        _store.load().then((_) {
          if (mounted) setState(() {});
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = _store.options;

    // Group options by group name for readability.
    final groups = <String, List<DevtoolsCustomOption>>{};
    for (final option in options) {
      final groupName = option.group ?? 'General';
      groups.putIfAbsent(groupName, () => []).add(option);
    }

    if (options.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.tune, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(widget.title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'No custom options registered yet.\n\n'
                'Register feature flags during bootstrap:\n\n'
                'DevtoolsCustomOptionsStore.instance.register(\n'
                '  DevtoolsCustomOption(\n'
                "    key: 'show_new_home',\n"
                "    label: 'Show new home UI',\n"
                "    group: 'Feature flags',\n"
                '  ),\n'
                ');',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
      );
    }

    final hasOverrides = _store.options.any(
      (o) => _store.valueOf(o.key) != o.defaultValue,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${options.length} options',
                  style: theme.textTheme.labelMedium,
                ),
              ),
              if (hasOverrides)
                TextButton.icon(
                  onPressed: () async {
                    await _store.resetAll();
                    if (mounted) setState(() {});
                  },
                  icon: const Icon(Icons.restart_alt, size: 16),
                  label: const Text('Reset'),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            children: [
              for (final entry in groups.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                  child: Text(
                    entry.key.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var i = 0; i < entry.value.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        _OptionTile(
                          option: entry.value[i],
                          value: _store.valueOf(entry.value[i].key),
                          onChanged: (v) async {
                            await _store.setOverride(entry.value[i].key, v);
                            if (mounted) setState(() {});
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.value,
    required this.onChanged,
  });

  final DevtoolsCustomOption option;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      dense: true,
      value: value,
      onChanged: onChanged,
      title: Text(option.label),
      subtitle: option.description.isEmpty
          ? null
          : Text(
              option.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
      secondary: Icon(
        value ? Icons.flag : Icons.flag_outlined,
        color: value ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }
}

/// Convenience helper to read a custom option value anywhere in the app.
///
/// ```dart
/// if (DevtoolsCustomOptions.value('show_new_home')) { ... }
/// ```
class DevtoolsCustomOptions {
  DevtoolsCustomOptions._();

  /// Reads the effective value for [key] from the global store.
  static bool value(String key) =>
      DevtoolsCustomOptionsStore.instance.valueOf(key);

  /// Reads the effective value for [option].
  static bool isEnabled(DevtoolsCustomOption option) =>
      DevtoolsCustomOptionsStore.instance.isEnabled(option);

  /// Registers [options] into the global store.
  static void registerAll(Iterable<DevtoolsCustomOption> options) =>
      DevtoolsCustomOptionsStore.instance.registerAll(options);

  /// Registers a single [option] into the global store.
  static void register(DevtoolsCustomOption option) =>
      DevtoolsCustomOptionsStore.instance.register(option);
}
