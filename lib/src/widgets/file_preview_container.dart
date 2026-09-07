import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

/// Supported source types for previewing files.
enum FileSourceType { network, file, asset }

/// Supported file formats for previewing.
enum FileType { image, pdf }

/// A highly reusable, enterprise-grade File Preview container and screen.
///
/// Features:
/// - Supports [FileSourceType.network], [FileSourceType.file], and [FileSourceType.asset].
/// - Interactive Pan, Zoom & Double-tap gesture support for Images ([InteractiveViewer]).
/// - Robust PDF document viewer with dynamic page tracking, custom navigation bar, and error recovery.
/// - Flexible styling: custom theme, background color, app bar actions, title, error/loading builders.
/// - Can be embedded directly as a Widget container or pushed modally via [FilePreviewContainer.show].
///
/// ---
///
/// ### 📖 Easy Usage Examples:
///
/// #### 1. Open as a Full Screen Modal Route:
/// ```dart
/// // Open an Image from Network:
/// FilePreviewContainer.show(
///   context,
///   filePath: 'https://example.com/sample.jpg',
///   fileType: FileType.image,
///   title: 'Profile Picture',
/// );
///
/// // Open a PDF Document from Local Storage:
/// FilePreviewContainer.show(
///   context,
///   filePath: '/path/to/invoice.pdf',
///   fileType: FileType.pdf,
///   sourceType: FileSourceType.file,
///   title: 'Tax Invoice',
///   appBarBackgroundColor: Colors.indigo,
///   controlsBackgroundColor: Colors.indigo.shade50,
/// );
/// ```
///
/// #### 2. Create a Dedicated Custom Screen / Page:
/// ```dart
/// class MyInvoicePreviewScreen extends StatelessWidget {
///   const MyInvoicePreviewScreen({super.key, required this.pdfUrl});
///   final String pdfUrl;
///
///   @override
///   Widget build(BuildContext context) {
///     return FilePreviewContainer(
///       filePath: pdfUrl,
///       fileType: FileType.pdf,
///       sourceType: FileSourceType.network,
///       title: 'Monthly Invoice',
///       actions: [
///         IconButton(
///           icon: const Icon(Icons.share),
///           onPressed: () => shareInvoice(pdfUrl),
///         ),
///       ],
///     );
///   }
/// }
/// ```
///
/// #### 3. Embed Directly as an Inline Widget (Inside Custom Layout / Tab):
/// ```dart
/// class InlineDocumentViewerCard extends StatelessWidget {
///   const InlineDocumentViewerCard({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return ClipRRect(
///       borderRadius: BorderRadius.circular(16),
///       child: SizedBox(
///         height: 350,
///         child: FilePreviewContainer(
///           filePath: 'assets/sample.pdf',
///           fileType: FileType.pdf,
///           sourceType: FileSourceType.asset,
///           showAppBar: false, // Disables AppBar for embedded containers
///         ),
///       ),
///     );
///   }
/// }
/// ```
class FilePreviewContainer extends StatefulWidget {
  const FilePreviewContainer({
    super.key,
    required this.filePath,
    required this.fileType,
    this.sourceType = FileSourceType.network,
    this.title,
    this.showAppBar = true,
    this.actions,
    this.heroTag,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.controlsBackgroundColor,
    this.controlsForegroundColor,
    this.loadingWidget,
    this.errorWidgetBuilder,
    this.minScale = 0.5,
    this.maxScale = 4.0,
    this.onPageChanged,
    this.onPdfRendered,
  });

  /// The target file URL, local file system path, or bundled asset path.
  final String filePath;

  /// The type of file to render ([FileType.image] or [FileType.pdf]).
  final FileType fileType;

  /// Origin source type ([FileSourceType.network], [FileSourceType.file], or [FileSourceType.asset]).
  final FileSourceType sourceType;

  /// Optional AppBar title.
  final String? title;

  /// Whether to render the Scaffold AppBar (default `true`). Set to `false` when embedding as a container.
  final bool showAppBar;

  /// Optional custom action buttons in the AppBar.
  final List<Widget>? actions;

  /// Optional Hero animation tag for smooth image transitions.
  final String? heroTag;

  /// Custom background color of the viewer container/scaffold.
  final Color? backgroundColor;

  /// Custom background color for the AppBar.
  final Color? appBarBackgroundColor;

  /// Custom icon/text color for the AppBar.
  final Color? appBarForegroundColor;

  /// Custom background color for the PDF bottom page controls.
  final Color? controlsBackgroundColor;

  /// Custom icon/text color for the PDF bottom page controls.
  final Color? controlsForegroundColor;

  /// Custom loading widget. Defaults to [CircularProgressIndicator.adaptive].
  final Widget? loadingWidget;

  /// Custom error builder when image or PDF fails to load.
  final Widget Function(BuildContext context, Object error)? errorWidgetBuilder;

  /// Minimum interactive zoom scale for images.
  final double minScale;

  /// Maximum interactive zoom scale for images.
  final double maxScale;

  /// Callback when PDF active page changes.
  final void Function(int currentPage, int totalPages)? onPageChanged;

  /// Callback when PDF rendering completes.
  final ValueChanged<int>? onPdfRendered;

  /// Helper factory to launch the [FilePreviewContainer] as a full modal route.
  static Future<T?> show<T>(
    BuildContext context, {
    required String filePath,
    required FileType fileType,
    FileSourceType sourceType = FileSourceType.network,
    String? title,
    bool showAppBar = true,
    List<Widget>? actions,
    String? heroTag,
    Color? backgroundColor,
    Color? appBarBackgroundColor,
    Color? appBarForegroundColor,
    Color? controlsBackgroundColor,
    Color? controlsForegroundColor,
    Widget? loadingWidget,
    Widget Function(BuildContext context, Object error)? errorWidgetBuilder,
    double minScale = 0.5,
    double maxScale = 4.0,
    void Function(int currentPage, int totalPages)? onPageChanged,
    ValueChanged<int>? onPdfRendered,
    bool useRootNavigator = true,
  }) {
    return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
      MaterialPageRoute<T>(
        builder: (_) => FilePreviewContainer(
          filePath: filePath,
          fileType: fileType,
          sourceType: sourceType,
          title: title,
          showAppBar: showAppBar,
          actions: actions,
          heroTag: heroTag,
          backgroundColor: backgroundColor,
          appBarBackgroundColor: appBarBackgroundColor,
          appBarForegroundColor: appBarForegroundColor,
          controlsBackgroundColor: controlsBackgroundColor,
          controlsForegroundColor: controlsForegroundColor,
          loadingWidget: loadingWidget,
          errorWidgetBuilder: errorWidgetBuilder,
          minScale: minScale,
          maxScale: maxScale,
          onPageChanged: onPageChanged,
          onPdfRendered: onPdfRendered,
        ),
      ),
    );
  }

  @override
  State<FilePreviewContainer> createState() => _FilePreviewContainerState();
}

class _FilePreviewContainerState extends State<FilePreviewContainer> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isPdfReady = false;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBg = widget.fileType == FileType.image
        ? Colors.black
        : theme.colorScheme.surface;
    final effectiveBg = widget.backgroundColor ?? defaultBg;

    final bodyContent = widget.fileType == FileType.image
        ? _buildImageViewer(context)
        : _buildPdfViewer(context);

    if (!widget.showAppBar) {
      return Container(
        color: effectiveBg,
        child: Column(
          children: [
            Expanded(child: bodyContent),
            if (widget.fileType == FileType.pdf && _isPdfReady)
              _buildPdfPageController(context),
          ],
        ),
      );
    }

    final defaultTitle = widget.fileType == FileType.image
        ? 'Image Preview'
        : 'Document Preview';

    return Scaffold(
      backgroundColor: effectiveBg,
      appBar: AppBar(
        title: Text(widget.title ?? defaultTitle),
        backgroundColor: widget.appBarBackgroundColor,
        foregroundColor: widget.appBarForegroundColor,
        actions: widget.actions,
      ),
      body: bodyContent,
      bottomNavigationBar: widget.fileType == FileType.pdf && _isPdfReady
          ? _buildPdfPageController(context)
          : null,
    );
  }

  Widget _buildImageViewer(BuildContext context) {
    Widget imageWidget;

    switch (widget.sourceType) {
      case FileSourceType.network:
        imageWidget = Image.network(
          widget.filePath,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child:
                  widget.loadingWidget ??
                  const CircularProgressIndicator.adaptive(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            if (widget.errorWidgetBuilder != null) {
              return widget.errorWidgetBuilder!(context, error);
            }
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.broken_image_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          },
        );
        break;

      case FileSourceType.file:
        imageWidget = Image.file(
          File(widget.filePath),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            if (widget.errorWidgetBuilder != null) {
              return widget.errorWidgetBuilder!(context, error);
            }
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.broken_image_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Local image file not found',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          },
        );
        break;

      case FileSourceType.asset:
        imageWidget = Image.asset(widget.filePath, fit: BoxFit.contain);
        break;
    }

    if (widget.heroTag != null) {
      imageWidget = Hero(tag: widget.heroTag!, child: imageWidget);
    }

    return InteractiveViewer(
      minScale: widget.minScale,
      maxScale: widget.maxScale,
      child: Center(child: imageWidget),
    );
  }

  Widget _buildPdfViewer(BuildContext context) {
    return Stack(
      children: [
        PDFView(
          filePath: widget.filePath,
          onRender: (pages) {
            setState(() {
              _totalPages = pages ?? 0;
              _isPdfReady = true;
            });
            if (pages != null) {
              widget.onPdfRendered?.call(pages);
            }
          },
          onViewCreated: (controller) {
            _pdfViewController = controller;
          },
          onPageChanged: (page, total) {
            final cur = page ?? 0;
            final tot = total ?? _totalPages;
            setState(() {
              _currentPage = cur;
              _totalPages = tot;
            });
            widget.onPageChanged?.call(cur + 1, tot);
          },
          onError: (error) {
            if (widget.errorWidgetBuilder != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error loading PDF: $error')),
              );
            }
          },
        ),
        if (!_isPdfReady)
          Center(
            child:
                widget.loadingWidget ??
                const CircularProgressIndicator.adaptive(),
          ),
      ],
    );
  }

  Widget _buildPdfPageController(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        widget.controlsBackgroundColor ??
        theme.colorScheme.surfaceContainerHighest;
    final fgColor =
        widget.controlsForegroundColor ?? theme.colorScheme.onSurface;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: fgColor),
            onPressed: _currentPage > 0
                ? () => _pdfViewController?.setPage(_currentPage - 1)
                : null,
          ),
          Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: TextStyle(color: fgColor, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: fgColor),
            onPressed: _currentPage < _totalPages - 1
                ? () => _pdfViewController?.setPage(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias for [FilePreviewContainer].
typedef FilePreviewPage = FilePreviewContainer;
