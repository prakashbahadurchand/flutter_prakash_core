import 'package:flutter/material.dart';
import 'admin_theme_config.dart';

/// 12-column responsive layout column definition.
class ResponsiveGridCol extends StatelessWidget {
  /// Grid span on extra-small/mobile screens (< 600px). Range: 1 to 12.
  final int xs;

  /// Grid span on small/tablet screens (600px - 1024px). Range: 1 to 12.
  final int? sm;

  /// Grid span on medium/desktop screens (1024px - 1440px). Range: 1 to 12.
  final int? md;

  /// Grid span on large/ultra-wide screens (> 1440px). Range: 1 to 12.
  final int? lg;

  /// The child widget to render inside this column.
  final Widget child;

  const ResponsiveGridCol({
    super.key,
    this.xs = 12,
    this.sm,
    this.md,
    this.lg,
    required this.child,
  }) : assert(xs >= 1 && xs <= 12, 'xs span must be between 1 and 12');

  /// Resolves the effective span (1-12) for a given screen width.
  int getSpanForWidth(double width, AdminThemeConfig config) {
    if (width >= config.desktopBreakpoint && lg != null) {
      return lg!.clamp(1, 12);
    }
    if (width >= config.tabletBreakpoint && md != null) {
      return md!.clamp(1, 12);
    }
    if (width >= config.mobileBreakpoint && sm != null) {
      return sm!.clamp(1, 12);
    }
    return xs.clamp(1, 12);
  }

  @override
  Widget build(BuildContext context) => child;
}

/// A 12-column fluid responsive row container that automatically lays out
/// [ResponsiveGridCol] children wrapping across lines.
class ResponsiveGridRow extends StatelessWidget {
  /// Children columns forming the grid row.
  final List<ResponsiveGridCol> children;

  /// Horizontal spacing between columns.
  final double spacing;

  /// Vertical spacing between wrapped rows.
  final double runSpacing;

  /// Custom theme configuration override.
  final AdminThemeConfig? themeConfig;

  const ResponsiveGridRow({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.themeConfig,
  });

  @override
  Widget build(BuildContext context) {
    final config = themeConfig ?? AdminTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((col) {
            final int span = col.getSpanForWidth(totalWidth, config);

            // Calculate width considering spacing.
            // If span == 12, takes 100% of available width.
            final double colWidth;
            if (span >= 12) {
              colWidth = totalWidth;
            } else {
              // Number of columns that could fit in 12
              final double fraction = span / 12.0;
              // Available width minus the proportion of spacing
              colWidth = (totalWidth * fraction) - (spacing * (1.0 - fraction));
            }

            return SizedBox(
              width: colWidth.clamp(0.0, totalWidth),
              child: col.child,
            );
          }).toList(),
        );
      },
    );
  }
}

/// An auto-adapting grid wrapper that automatically calculates column counts
/// based on screen width breakpoints or explicit column overrides.
class ResponsiveGrid extends StatelessWidget {
  /// Grid child items.
  final List<Widget> children;

  /// Horizontal spacing between items.
  final double crossAxisSpacing;

  /// Vertical spacing between items.
  final double mainAxisSpacing;

  /// Aspect ratio of child items (width / height).
  final double childAspectRatio;

  /// Explicit column count override. If null, auto-calculated from breakpoints.
  final int? overrideColumns;

  /// Custom breakpoint column counts.
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int ultraWideColumns;

  /// Optional theme configuration override.
  final AdminThemeConfig? themeConfig;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.childAspectRatio = 1.4,
    this.overrideColumns,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.ultraWideColumns = 4,
    this.themeConfig,
  });

  /// Computes the auto-column count for the given constraints.
  int _calculateColumns(double width, AdminThemeConfig config) {
    if (overrideColumns != null) return overrideColumns!;
    if (width < config.mobileBreakpoint) return mobileColumns;
    if (width < config.tabletBreakpoint) return tabletColumns;
    if (width < config.desktopBreakpoint) return desktopColumns;
    return ultraWideColumns;
  }

  @override
  Widget build(BuildContext context) {
    final config = themeConfig ?? AdminTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns = _calculateColumns(constraints.maxWidth, config);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
