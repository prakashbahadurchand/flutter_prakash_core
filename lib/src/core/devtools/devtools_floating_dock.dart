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
    this.tooltip,
    this.navigatorKey,
    this.customTheme,
  });

  final Widget child;
  final bool enabled;
  final DockSide initialSide;
  final double margin;
  final double buttonSize;
  final String? tooltip;
  final GlobalKey<NavigatorState>? navigatorKey;
  final ThemeData? customTheme;

  @override
  State<DevtoolsFloatingDock> createState() => _DevtoolsFloatingDockState();
}

class _DevtoolsFloatingDockState extends State<DevtoolsFloatingDock>
    with SingleTickerProviderStateMixin {
  double? _x;
  double? _y;
  bool _isDragging = false;
  late AnimationController _animController;
  Animation<double>? _xAnimation;
  Animation<double>? _yAnimation;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 260),
        )..addListener(() {
          if (_xAnimation != null && _yAnimation != null) {
            setState(() {
              _x = _xAnimation!.value;
              _y = _yAnimation!.value;
            });
          }
        });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _snapToEdge(double maxWidth, double maxHeight) {
    if (_x == null || _y == null) return;

    final minX = widget.margin;
    final maxX = maxWidth - widget.buttonSize - widget.margin;
    final minY = widget.margin;
    final maxY = maxHeight - widget.buttonSize - widget.margin;

    final targetX = (_x! + widget.buttonSize / 2 < maxWidth / 2) ? minX : maxX;
    final targetY = _y!.clamp(minY, maxY);

    _xAnimation = Tween<double>(begin: _x, end: targetX).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _yAnimation = Tween<double>(begin: _y, end: targetY).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutQuad),
    );

    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return ValueListenableBuilder<bool>(
      valueListenable: DevToolsDialog.isOpen,
      builder: (context, isDialogOpen, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxH = constraints.maxHeight;
            final maxW = constraints.maxWidth;

            final minX = widget.margin;
            final maxX = maxW - widget.buttonSize - widget.margin;
            final minY = widget.margin;
            final maxY = maxH - widget.buttonSize - widget.margin;

            // Initialize default position on first layout
            if (_x == null || _y == null) {
              _x = (widget.initialSide == DockSide.left) ? minX : maxX;
              _y = (0.16 * maxH).clamp(minY, maxY);
            }

            final currentX = (_x ?? maxX).clamp(minX, maxX);
            final currentY = (_y ?? minY).clamp(minY, maxY);

            return Stack(
              alignment: Alignment.topLeft,
              children: [
                widget.child,
                if (!isDialogOpen)
                  Positioned(
                    left: currentX,
                    top: currentY,
                    child: GestureDetector(
                      onPanStart: (_) {
                        _animController.stop();
                        setState(() {
                          _isDragging = true;
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _x = ((_x ?? currentX) + details.delta.dx).clamp(
                            0.0,
                            maxW - widget.buttonSize,
                          );
                          _y = ((_y ?? currentY) + details.delta.dy).clamp(
                            0.0,
                            maxH - widget.buttonSize,
                          );
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _isDragging = false;
                        });
                        _snapToEdge(maxW, maxH);
                      },
                      onPanCancel: () {
                        setState(() {
                          _isDragging = false;
                        });
                        _snapToEdge(maxW, maxH);
                      },
                      child: Directionality(
                        textDirection:
                            Directionality.maybeOf(context) ??
                            TextDirection.ltr,
                        child: AnimatedScale(
                          scale: _isDragging ? 1.12 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Opacity(
                            opacity: _isDragging ? 0.85 : 1.0,
                            child: FloatingActionButton.small(
                              backgroundColor: Colors.white,
                              elevation: _isDragging ? 6 : 2,
                              heroTag: 'devtools_dock_fab',
                              tooltip:
                                  (widget.tooltip != null &&
                                      widget.tooltip!.isNotEmpty)
                                  ? widget.tooltip
                                  : null,
                              onPressed: () => DevToolsDialog.show(
                                context,
                                navigatorKey: widget.navigatorKey,
                                customTheme: widget.customTheme,
                              ),
                              child: const Icon(
                                Icons.developer_mode,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
