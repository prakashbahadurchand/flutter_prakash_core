import 'package:flutter/material.dart';

/// Defines how the delete confirmation prompt is displayed.
enum DeleteConfirmationStyle {
  /// Displays an anchored contextual popup menu near the trigger location.
  popup,

  /// Displays a centered modal AlertDialog.
  dialog,
}

enum _ActionType { view, edit, delete }

/// Enterprise-grade, reusable action component for View, Edit, and Delete operations.
class ViewEditDeleteButton extends StatefulWidget {
  /// Callback executed when the "View" action is triggered.
  final Future<void> Function()? onView;

  /// Callback executed when the "Edit" action is triggered.
  final Future<void> Function()? onEdit;

  /// Callback executed when "Delete" is confirmed.
  final Future<void> Function()? onDelete;

  /// Display identifier of the target resource (e.g., "Order #ORD-9821").
  final String? itemName;

  /// Strategy used for confirming deletion: [DeleteConfirmationStyle.popup] or [DeleteConfirmationStyle.dialog].
  final DeleteConfirmationStyle confirmationStyle;

  /// Renders actions as an inline button row if `true`, or inside an overflow (`more_vert`) menu if `false`.
  final bool isInlineRow;

  // --- Role-Based Access Control (RBAC) ---
  final bool canView;
  final bool canEdit;
  final bool canDelete;

  // --- Localization & Customization ---
  final String viewTooltip;
  final String editTooltip;
  final String deleteTooltip;

  final IconData viewIcon;
  final IconData editIcon;
  final IconData deleteIcon;

  final Color? viewColor;
  final Color? editColor;
  final Color? deleteColor;

  final String deleteConfirmationTitle;
  final String? deleteConfirmationMessage;
  final String confirmDeleteText;
  final String cancelText;

  const ViewEditDeleteButton({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.itemName,
    this.confirmationStyle = DeleteConfirmationStyle.popup,
    this.isInlineRow = true,
    this.canView = true,
    this.canEdit = true,
    this.canDelete = true,
    this.viewTooltip = 'View Details',
    this.editTooltip = 'Edit Item',
    this.deleteTooltip = 'Delete Item',
    this.viewIcon = Icons.visibility_outlined,
    this.editIcon = Icons.edit_outlined,
    this.deleteIcon = Icons.delete_outline,
    this.viewColor,
    this.editColor,
    this.deleteColor,
    this.deleteConfirmationTitle = 'Confirm Delete',
    this.deleteConfirmationMessage,
    this.confirmDeleteText = 'Delete',
    this.cancelText = 'Cancel',
  });

  @override
  State<ViewEditDeleteButton> createState() => _ViewEditDeleteButtonState();
}

class _ViewEditDeleteButtonState extends State<ViewEditDeleteButton> {
  final GlobalKey _overflowKey = GlobalKey();
  final GlobalKey _deleteButtonKey = GlobalKey();

  /// Tracks the action currently processing (`null` if idle).
  _ActionType? _activeAction;

  bool get _isProcessing => _activeAction != null;

  Future<void> _executeAction(
    _ActionType type,
    Future<void> Function()? action,
  ) async {
    if (action == null || _isProcessing) return;

    setState(() => _activeAction = type);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _activeAction = null);
      }
    }
  }

  /// Builds a loader that precisely matches IconButton dimensions (40x40).
  Widget _buildInlineSpinner(Color color) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2.2, color: color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.viewColor ?? Theme.of(context).colorScheme.primary;
    final warningColor = widget.editColor ?? Colors.amber[800]!;
    final errorColor =
        widget.deleteColor ?? Theme.of(context).colorScheme.error;

    if (widget.isInlineRow) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // View Action Button / Loader
          if (widget.canView && widget.onView != null)
            _activeAction == _ActionType.view
                ? _buildInlineSpinner(primaryColor)
                : IconButton(
                    icon: Icon(widget.viewIcon, size: 20),
                    color: primaryColor,
                    tooltip: widget.viewTooltip,
                    onPressed: _isProcessing
                        ? null
                        : () => _executeAction(_ActionType.view, widget.onView),
                  ),

          // Edit Action Button / Loader
          if (widget.canEdit && widget.onEdit != null)
            _activeAction == _ActionType.edit
                ? _buildInlineSpinner(warningColor)
                : IconButton(
                    icon: Icon(widget.editIcon, size: 20),
                    color: warningColor,
                    tooltip: widget.editTooltip,
                    onPressed: _isProcessing
                        ? null
                        : () => _executeAction(_ActionType.edit, widget.onEdit),
                  ),

          // Delete Action Button / Loader
          if (widget.canDelete && widget.onDelete != null)
            _activeAction == _ActionType.delete
                ? _buildInlineSpinner(errorColor)
                : _buildInlineDeleteButton(context, errorColor),
        ],
      );
    }

    // Overflow Menu Mode (isInlineRow = false)
    if (_isProcessing) {
      return _buildInlineSpinner(Theme.of(context).colorScheme.primary);
    }

    return PopupMenuButton<_ActionType>(
      key: _overflowKey,
      icon: const Icon(Icons.more_vert),
      tooltip: 'Actions',
      onSelected: (_ActionType action) async {
        switch (action) {
          case _ActionType.view:
            await _executeAction(_ActionType.view, widget.onView);
            break;
          case _ActionType.edit:
            await _executeAction(_ActionType.edit, widget.onEdit);
            break;
          case _ActionType.delete:
            await _handleDeleteTrigger(context, _overflowKey);
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (widget.canView && widget.onView != null)
            PopupMenuItem<_ActionType>(
              value: _ActionType.view,
              child: Row(
                children: [
                  Icon(widget.viewIcon, size: 20, color: primaryColor),
                  const SizedBox(width: 12),
                  Text(widget.viewTooltip),
                ],
              ),
            ),
          if (widget.canEdit && widget.onEdit != null)
            PopupMenuItem<_ActionType>(
              value: _ActionType.edit,
              child: Row(
                children: [
                  Icon(widget.editIcon, size: 20, color: warningColor),
                  const SizedBox(width: 12),
                  Text(widget.editTooltip),
                ],
              ),
            ),
          if (widget.canDelete && widget.onDelete != null) ...[
            if (widget.canView || widget.canEdit) const PopupMenuDivider(),
            PopupMenuItem<_ActionType>(
              value: _ActionType.delete,
              child: Row(
                children: [
                  Icon(widget.deleteIcon, size: 20, color: errorColor),
                  const SizedBox(width: 12),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ];
      },
    );
  }

  Widget _buildInlineDeleteButton(BuildContext context, Color errorColor) {
    if (widget.confirmationStyle == DeleteConfirmationStyle.popup) {
      return PopupMenuButton<bool>(
        key: _deleteButtonKey,
        enabled: !_isProcessing,
        tooltip: widget.deleteTooltip,
        icon: Icon(widget.deleteIcon, size: 20, color: errorColor),
        onSelected: (bool confirmed) async {
          if (confirmed) {
            await _executeAction(_ActionType.delete, widget.onDelete);
          }
        },
        itemBuilder: (BuildContext context) => _buildDeletePopupItems(context),
      );
    }

    return IconButton(
      key: _deleteButtonKey,
      icon: Icon(widget.deleteIcon, size: 20),
      color: errorColor,
      tooltip: widget.deleteTooltip,
      onPressed: _isProcessing
          ? null
          : () => _showDeleteConfirmationDialog(context),
    );
  }

  Future<void> _handleDeleteTrigger(
    BuildContext context,
    GlobalKey anchorKey,
  ) async {
    if (widget.confirmationStyle == DeleteConfirmationStyle.dialog) {
      await _showDeleteConfirmationDialog(context);
    } else {
      await _showDeleteConfirmationPopup(context, anchorKey);
    }
  }

  Future<void> _showDeleteConfirmationPopup(
    BuildContext context,
    GlobalKey anchorKey,
  ) async {
    final RenderBox? renderBox =
        anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;

    if (renderBox == null || overlay == null) {
      await _executeAction(_ActionType.delete, widget.onDelete);
      return;
    }

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderBox.localToGlobal(Offset.zero, ancestor: overlay),
        renderBox.localToGlobal(
          renderBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final confirmed = await showMenu<bool>(
      context: context,
      position: position,
      items: _buildDeletePopupItems(context),
    );

    if (confirmed == true) {
      await _executeAction(_ActionType.delete, widget.onDelete);
    }
  }

  List<PopupMenuEntry<bool>> _buildDeletePopupItems(BuildContext context) {
    final errorColor =
        widget.deleteColor ?? Theme.of(context).colorScheme.error;

    return [
      PopupMenuItem<bool>(
        enabled: false,
        child: Text(
          widget.itemName != null
              ? 'Delete "${widget.itemName}"?'
              : widget.deleteConfirmationTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
      PopupMenuItem<bool>(
        value: true,
        child: Row(
          children: [
            Icon(Icons.delete_forever, size: 18, color: errorColor),
            const SizedBox(width: 8),
            Text(
              widget.confirmDeleteText,
              style: TextStyle(color: errorColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final errorColor = widget.deleteColor ?? theme.colorScheme.error;

    final String messageText =
        widget.deleteConfirmationMessage ??
        (widget.itemName != null
            ? 'Are you sure you want to delete "${widget.itemName}"? This action cannot be undone.'
            : 'Are you sure you want to delete this item? This action cannot be undone.');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Icon(Icons.warning_amber_rounded, size: 40, color: errorColor),
          title: Text(widget.deleteConfirmationTitle),
          content: Text(messageText),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(widget.cancelText),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: errorColor,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(widget.confirmDeleteText),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _executeAction(_ActionType.delete, widget.onDelete);
    }
  }
}
