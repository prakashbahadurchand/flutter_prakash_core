import 'package:flutter/material.dart';

/// Enterprise-grade card wrapper for tabular data displays.
/// Includes built-in live search bar, filter action slots, refresh callback,
/// export actions, loading overlay, empty state, and error handling.
class DataTableCard extends StatefulWidget {
  /// Card header title string or widget.
  final String? title;

  /// Optional subtitle or helper text displayed beneath the title.
  final String? subtitle;

  /// Optional custom leading widget displayed in the table header.
  final Widget? headerLeading;

  /// Search field placeholder hint text.
  final String searchHint;

  /// Callback triggered when search input changes.
  final ValueChanged<String>? onSearchChanged;

  /// Initial search query if controlled externally.
  final String? initialSearchQuery;

  /// Custom filter widgets (e.g. dropdowns, date pickers, filter chips).
  final List<Widget>? filterWidgets;

  /// Primary action widgets displayed in the header (e.g. "Export CSV", "Add Item").
  final List<Widget>? actions;

  /// Callback executed when the refresh button is pressed.
  final Future<void> Function()? onRefresh;

  /// Whether the table is currently loading data.
  final bool isLoading;

  /// Whether the dataset is currently empty.
  final bool isEmpty;

  /// Message displayed in default empty state.
  final String emptyMessage;

  /// Icon displayed in default empty state.
  final IconData emptyIcon;

  /// Custom empty state builder.
  final WidgetBuilder? emptyBuilder;

  /// Error message if an error occurred while fetching table data.
  final String? errorMessage;

  /// Custom error state builder.
  final Widget Function(BuildContext context, String error)? errorBuilder;

  /// The tabular content widget (e.g. [DataTable], [PaginatedDataTable], or custom table).
  final Widget child;

  /// Custom card elevation.
  final double elevation;

  /// Custom card border radius.
  final BorderRadius? borderRadius;

  /// Custom card background color.
  final Color? backgroundColor;

  /// Custom padding around the card body.
  final EdgeInsetsGeometry padding;

  /// Whether to display the search bar. Defaults to true if [onSearchChanged] is provided.
  final bool showSearchBar;

  const DataTableCard({
    super.key,
    this.title,
    this.subtitle,
    this.headerLeading,
    this.searchHint = 'Search...',
    this.onSearchChanged,
    this.initialSearchQuery,
    this.filterWidgets,
    this.actions,
    this.onRefresh,
    this.isLoading = false,
    this.isEmpty = false,
    this.emptyMessage = 'No records found',
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyBuilder,
    this.errorMessage,
    this.errorBuilder,
    required this.child,
    this.elevation = 0.0,
    this.borderRadius,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.showSearchBar = true,
  });

  @override
  State<DataTableCard> createState() => _DataTableCardState();
}

class _DataTableCardState extends State<DataTableCard> {
  late final TextEditingController _searchController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.initialSearchQuery ?? '',
    );
  }

  @override
  void didUpdateWidget(DataTableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSearchQuery != null &&
        widget.initialSearchQuery != oldWidget.initialSearchQuery &&
        widget.initialSearchQuery != _searchController.text) {
      _searchController.text = widget.initialSearchQuery!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (widget.onRefresh == null || _isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      await widget.onRefresh!();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius =
        widget.borderRadius ?? const BorderRadius.all(Radius.circular(12));
    final effectiveBg = widget.backgroundColor ?? theme.colorScheme.surface;
    final isMobile = MediaQuery.sizeOf(context).width < 600.0;

    return Card(
      elevation: widget.elevation,
      color: effectiveBg,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveBorderRadius,
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar: Title, Subtitle, Actions & Refresh
          if (widget.title != null ||
              widget.actions != null ||
              widget.onRefresh != null)
            _buildCardHeader(context, theme, isMobile),

          // Search and Filters Bar
          if ((widget.showSearchBar && widget.onSearchChanged != null) ||
              (widget.filterWidgets != null &&
                  widget.filterWidgets!.isNotEmpty))
            _buildSearchAndFiltersBar(context, theme, isMobile),

          // Loading Progress Bar
          if (widget.isLoading || _isRefreshing)
            const LinearProgressIndicator(minHeight: 2.5),

          // Card Content: Error State, Empty State, or Table Widget
          Padding(padding: widget.padding, child: _buildBody(context, theme)),
        ],
      ),
    );
  }

  Widget _buildCardHeader(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.08)),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(theme),
                if (widget.actions != null || widget.onRefresh != null) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (widget.actions != null) ...widget.actions!,
                      if (widget.onRefresh != null) _buildRefreshButton(theme),
                    ],
                  ),
                ],
              ],
            )
          : Row(
              children: [
                Expanded(child: _buildTitleSection(theme)),
                if (widget.actions != null) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: widget.actions!,
                  ),
                  const SizedBox(width: 8),
                ],
                if (widget.onRefresh != null) _buildRefreshButton(theme),
              ],
            ),
    );
  }

  Widget _buildTitleSection(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.headerLeading != null) ...[
          widget.headerLeading!,
          const SizedBox(width: 12),
        ],
        if (widget.title != null)
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRefreshButton(ThemeData theme) {
    return IconButton(
      icon: _isRefreshing
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.refresh_rounded, size: 20),
      tooltip: 'Refresh data',
      onPressed: _isRefreshing ? null : _handleRefresh,
    );
  }

  Widget _buildSearchAndFiltersBar(
    BuildContext context,
    ThemeData theme,
    bool isMobile,
  ) {
    final searchWidget =
        (widget.showSearchBar && widget.onSearchChanged != null)
        ? SizedBox(
            width: isMobile ? double.infinity : 280,
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchChanged?.call('');
                          setState(() {});
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                  ),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerLow,
              ),
              onChanged: (query) {
                setState(() {});
                widget.onSearchChanged?.call(query);
              },
            ),
          )
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.08)),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?searchWidget,
                if (widget.filterWidgets != null &&
                    widget.filterWidgets!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: widget.filterWidgets!,
                  ),
                ],
              ],
            )
          : Row(
              children: [
                ?searchWidget,
                if (widget.filterWidgets != null &&
                    widget.filterWidgets!.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: widget.filterWidgets!,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    // 1. Error State
    if (widget.errorMessage != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, widget.errorMessage!);
      }
      return _buildDefaultErrorState(theme);
    }

    // 2. Empty State
    if (widget.isEmpty && !widget.isLoading) {
      if (widget.emptyBuilder != null) {
        return widget.emptyBuilder!(context);
      }
      return _buildDefaultEmptyState(theme);
    }

    // 3. Table content
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width - 64,
        ),
        child: widget.child,
      ),
    );
  }

  Widget _buildDefaultEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.emptyIcon,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              widget.emptyMessage,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultErrorState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              widget.errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.onRefresh != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: _handleRefresh,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
