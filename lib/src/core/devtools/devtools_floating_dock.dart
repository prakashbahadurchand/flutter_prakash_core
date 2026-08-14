import 'package:flutter/material.dart';
import 'package:flutter_prakash/src/core/devtools/devtools_dialog.dart';

enum DockSide { left, right }

/// Floating DevTools dock overlay widget. Wrap your app child inside this widget
/// or put in `MaterialApp(builder: ...)` to access DevTools from anywhere.
class DevtoolsFloatingDock extends StatefulWidget {
  const DevtoolsFloatingDock({
    required this.child,
    super.key,
    this.enabled = true,
    this.initialSide = DockSide.right,
    this.margin = 4,
    this.buttonSize = 36,
    this.tooltip = 'DevTools',
  });

  final Widget child;
  final bool enabled;
  final DockSide initialSide;
  final double margin;
  final double buttonSize;
  final String tooltip;

  @override
  State<DevtoolsFloatingDock> createState() => _DevtoolsFloatingDockState();
}

class _DevtoolsFloatingDockState extends State<DevtoolsFloatingDock> {
  double _yNorm = 0.16;
  late DockSide _side;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _side = widget.initialSide;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        final maxW = constraints.maxWidth;

        final yPos = (_yNorm * maxH).clamp(
          widget.margin,
          maxH - widget.buttonSize - widget.margin,
        );

        final double xPos = (_side == DockSide.left)
            ? widget.margin
            : maxW - widget.buttonSize - widget.margin;

        return Stack(
          children: [
            widget.child,
            Positioned(
              left: xPos,
              top: yPos,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _isDragging = true;
                    final newY = yPos + details.delta.dy;
                    _yNorm = (newY / maxH).clamp(0.02, 0.95);
                  });
                },
                onVerticalDragEnd: (_) {
                  setState(() {
                    _isDragging = false;
                  });
                },
                onHorizontalDragEnd: (details) {
                  final dx = details.velocity.pixelsPerSecond.dx;
                  if (dx.abs() > 200) {
                    setState(() {
                      _side = dx > 0 ? DockSide.right : DockSide.left;
                    });
                  }
                },
                child: Opacity(
                  opacity: _isDragging ? 0.7 : 1.0,
                  child: FloatingActionButton.small(
                    heroTag: 'devtools_dock_fab',
                    tooltip: widget.tooltip,
                    onPressed: () => DevToolsDialog.show(context),
                    child: const Icon(Icons.bug_report, size: 20),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
