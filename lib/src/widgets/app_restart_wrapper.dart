import 'package:flutter/material.dart';

/// Generic application restart wrapper widget that enables hot app resetting/rebuilding.
///
/// Wraps the root application widget and provides [forceRebuild] to trigger a complete
/// rebuild with a fresh key state and optional [onRestart] async callback.
class AppRestartWrapper extends StatefulWidget {
  const AppRestartWrapper({
    super.key,
    required this.child,
    this.onRestart,
    this.loadingMessage = 'Refreshing Environment...',
  });

  final Widget child;
  final Future<void> Function()? onRestart;
  final String loadingMessage;

  /// Static helper to trigger a full application restart from any [BuildContext].
  static Future<void> forceRebuild(BuildContext context) async {
    final state = context.findAncestorStateOfType<_AppRestartWrapperState>();
    if (state != null) {
      await state.restart();
    }
  }

  @override
  State<AppRestartWrapper> createState() => _AppRestartWrapperState();
}

class _AppRestartWrapperState extends State<AppRestartWrapper> {
  Key _key = UniqueKey();
  bool _isRestarting = false;

  Future<void> restart() async {
    setState(() => _isRestarting = true);

    try {
      if (widget.onRestart != null) {
        await widget.onRestart!();
      }
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (_) {
      // Ignore restart callback errors gracefully
    } finally {
      if (mounted) {
        setState(() {
          _key = UniqueKey();
          _isRestarting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            widget.child,
            if (_isRestarting)
              Material(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.blue),
                      const SizedBox(height: 20),
                      Text(
                        widget.loadingMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
