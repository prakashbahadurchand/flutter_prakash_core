import 'package:flutter/material.dart';
import 'admin_types.dart';

/// Enterprise KPI and status metric card with trend indicators, status badges,
/// custom icons, and skeleton loading support.
class MetricCard extends StatelessWidget {
  /// Primary metric title or metric name (e.g. "Total Revenue").
  final String title;

  /// Highlighted metric value string (e.g. "$128,430.00").
  final String value;

  /// Optional contextual sub-label or comparison text (e.g. "vs last month").
  final String? subLabel;

  /// Trend percentage or difference string (e.g. "+12.5%", "-3.2%").
  final String? change;

  /// Direction of the trend (up, down, neutral).
  final TrendDirection trend;

  /// Whether positive upward trend is considered good (green) or bad (red).
  /// Inverting is useful for metrics like error rate or latency where decreases are positive.
  final bool isTrendInverted;

  /// Custom leading icon or widget.
  final Widget? leading;

  /// Custom trailing widget (e.g. contextual menu, sparkline, or info icon).
  final Widget? trailing;

  /// Optional status badge text (e.g. "Live", "Delayed", "Target Reached").
  final String? badgeText;

  /// Optional custom background color for the status badge.
  final Color? badgeColor;

  /// Optional custom text color for the status badge.
  final Color? badgeTextColor;

  /// Presentation style variant (standard, compact, outlined, filled).
  final MetricCardVariant variant;

  /// Whether this metric card is currently loading, displaying a skeleton placeholder.
  final bool isLoading;

  /// Click action callback.
  final VoidCallback? onTap;

  /// Custom card background color override.
  final Color? backgroundColor;

  /// Custom card border color override.
  final Color? borderColor;

  /// Custom card border radius override.
  final BorderRadius? borderRadius;

  /// Custom internal padding override.
  final EdgeInsetsGeometry? padding;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subLabel,
    this.change,
    this.trend = TrendDirection.neutral,
    this.isTrendInverted = false,
    this.leading,
    this.trailing,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
    this.variant = MetricCardVariant.standard,
    this.isLoading = false,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
  });

  /// Resolves the trend text and icon color based on direction and invert setting.
  Color _resolveTrendColor(ThemeData theme) {
    final bool isPositiveEffective = isTrendInverted
        ? trend == TrendDirection.down
        : trend == TrendDirection.up;

    switch (trend) {
      case TrendDirection.up:
        return isPositiveEffective
            ? Colors.green.shade600
            : theme.colorScheme.error;
      case TrendDirection.down:
        return isPositiveEffective
            ? Colors.green.shade600
            : theme.colorScheme.error;
      case TrendDirection.neutral:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  /// Resolves the trend icon based on direction.
  IconData _resolveTrendIcon() {
    switch (trend) {
      case TrendDirection.up:
        return Icons.arrow_upward_rounded;
      case TrendDirection.down:
        return Icons.arrow_downward_rounded;
      case TrendDirection.neutral:
        return Icons.remove_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius =
        borderRadius ?? const BorderRadius.all(Radius.circular(12));
    final effectivePadding =
        padding ??
        (variant == MetricCardVariant.compact
            ? const EdgeInsets.all(12)
            : const EdgeInsets.all(20));

    // Resolve surface color by variant
    Color surfaceColor;
    Border? border;

    switch (variant) {
      case MetricCardVariant.standard:
        surfaceColor = backgroundColor ?? theme.colorScheme.surface;
        border = Border.all(
          color: borderColor ?? theme.dividerColor.withValues(alpha: 0.15),
        );
        break;
      case MetricCardVariant.compact:
        surfaceColor = backgroundColor ?? theme.colorScheme.surface;
        border = Border.all(
          color: borderColor ?? theme.dividerColor.withValues(alpha: 0.12),
        );
        break;
      case MetricCardVariant.outlined:
        surfaceColor = backgroundColor ?? Colors.transparent;
        border = Border.all(
          color:
              borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.3),
        );
        break;
      case MetricCardVariant.filled:
        surfaceColor =
            backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
        border = borderColor != null ? Border.all(color: borderColor!) : null;
        break;
    }

    if (isLoading) {
      return _buildSkeleton(
        theme,
        surfaceColor,
        border,
        effectiveBorderRadius,
        effectivePadding,
      );
    }

    final trendColor = _resolveTrendColor(theme);

    return Material(
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: border?.top ?? BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: effectiveBorderRadius,
        child: Padding(
          padding: effectivePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Row: Leading + Title & Badge + Trailing
              Row(
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 12)],
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          _buildStatusBadge(theme),
                        ],
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
              const SizedBox(height: 12),

              // Highlighted Primary Value
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Footer Row: Trend percentage + contextual sub-label
              if (change != null || subLabel != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (change != null) ...[
                      Icon(_resolveTrendIcon(), size: 16, color: trendColor),
                      const SizedBox(width: 4),
                      Text(
                        change!,
                        style: TextStyle(
                          color: trendColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (subLabel != null)
                      Expanded(
                        child: Text(
                          subLabel!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final bg = badgeColor ?? theme.colorScheme.primaryContainer;
    final fg = badgeTextColor ?? theme.colorScheme.onPrimaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        badgeText!,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSkeleton(
    ThemeData theme,
    Color surfaceColor,
    Border? border,
    BorderRadius effectiveBorderRadius,
    EdgeInsetsGeometry effectivePadding,
  ) {
    final placeholderColor = theme.dividerColor.withValues(alpha: 0.1);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: effectiveBorderRadius,
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 14,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 140,
            height: 28,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 100,
            height: 12,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }
}
