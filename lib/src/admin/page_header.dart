import 'package:flutter/material.dart';
import 'admin_types.dart';

/// Standardized enterprise page-level header containing dynamic breadcrumbs,
/// title, subtitle, and responsive action controls.
class PageHeader extends StatelessWidget {
  /// Primary page title string.
  final String title;

  /// Optional contextual subtitle or descriptive guide text.
  final String? subtitle;

  /// Breadcrumb path segments representing current page hierarchy.
  final List<AdminBreadcrumbItem> breadcrumbs;

  /// Action buttons rendered in the header bar (e.g. "Create Order", "Export CSV").
  final List<Widget> actions;

  /// Optional leading widget before the title (e.g. Back button or icon).
  final Widget? leading;

  /// Custom padding around the page header. Defaults to 24px horizontal, 16px vertical.
  final EdgeInsetsGeometry? padding;

  /// Divider separating the breadcrumbs and title, or header from body.
  final bool showBottomDivider;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumbs = const <AdminBreadcrumbItem>[],
    this.actions = const <Widget>[],
    this.leading,
    this.padding,
    this.showBottomDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = MediaQuery.sizeOf(context).width < 600.0;
    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(vertical: 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: effectivePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dynamic Breadcrumbs Trail
              if (breadcrumbs.isNotEmpty) ...[
                _buildBreadcrumbs(context, theme),
                const SizedBox(height: 8),
              ],

              // Title and Actions Layout
              if (isCompact) ...[
                // Mobile stacked layout
                _buildTitleRow(theme),
                if (actions.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(spacing: 8, runSpacing: 8, children: actions),
                ],
              ] else ...[
                // Desktop / Tablet row layout
                Row(
                  children: [
                    Expanded(child: _buildTitleRow(theme)),
                    if (actions.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: actions,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
        if (showBottomDivider)
          Divider(height: 1, color: theme.dividerColor.withValues(alpha: 0.12)),
      ],
    );
  }

  Widget _buildBreadcrumbs(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(breadcrumbs.length, (index) {
          final item = breadcrumbs[index];
          final isLast = index == breadcrumbs.length - 1;

          final textWidget = Text(
            item.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
              color: isLast
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurfaceVariant,
            ),
          );

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.onTap != null && !isLast)
                InkWell(
                  onTap: item.onTap,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                        ],
                        textWidget,
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.icon != null) ...[
                        Icon(
                          item.icon,
                          size: 14,
                          color: isLast
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                      ],
                      textWidget,
                    ],
                  ),
                ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
