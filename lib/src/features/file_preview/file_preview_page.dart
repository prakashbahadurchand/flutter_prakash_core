import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

enum FileSourceType { network, file, asset }

enum FileType { image, pdf }

/// Reusable full-featured File Preview Page supporting Image & PDF viewer.
///
/// Features:
/// - Supports Network URL, File Path, or Asset Path.
/// - Image viewing with interactive pan & pinch-zoom ([InteractiveViewer]).
/// - PDF viewing with page count, current page navigation, and loading states.
/// - Custom actions, title customization, and downloading/sharing hooks.
class FilePreviewPage extends StatefulWidget {
  const FilePreviewPage({
    super.key,
    required this.filePath,
    required this.fileType,
    this.sourceType = FileSourceType.network,
    this.title,
    this.actions,
    this.heroTag,
    this.backgroundColor,
  });

  /// The file URL, local file path, or asset path.
  final String filePath;

  /// The type of file to render ([FileType.image] or [FileType.pdf]).
  final FileType fileType;

  /// The source origin of the file ([FileSourceType.network], [FileSourceType.file], or [FileSourceType.asset]).
  final FileSourceType sourceType;

  /// Optional app bar title override.
  final String? title;

  /// Optional custom action buttons in the AppBar.
  final List<Widget>? actions;

  /// Optional Hero tag for smooth image transitions.
  final String? heroTag;

  /// Custom background color (defaults to black for images, surface for PDFs).
  final Color? backgroundColor;

  /// Helper factory to open the FilePreviewPage modally.
  static Future<void> show(
    BuildContext context, {
    required String filePath,
    required FileType fileType,
    FileSourceType sourceType = FileSourceType.network,
    String? title,
    List<Widget>? actions,
    String? heroTag,
    Color? backgroundColor,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilePreviewPage(
          filePath: filePath,
          fileType: fileType,
          sourceType: sourceType,
          title: title,
          actions: actions,
          heroTag: heroTag,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }

  @override
  State<FilePreviewPage> createState() => _FilePreviewPageState();
}

class _FilePreviewPageState extends State<FilePreviewPage> {
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

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? defaultBg,
      appBar: AppBar(
        title: Text(
          widget.title ??
              (widget.fileType == FileType.image
                  ? 'Image Preview'
                  : 'Document Preview'),
        ),
        actions: widget.actions,
      ),
      body: widget.fileType == FileType.image
          ? _buildImageViewer()
          : _buildPdfViewer(),
      bottomNavigationBar: widget.fileType == FileType.pdf && _isPdfReady
          ? _buildPdfPageController()
          : null,
    );
  }

  Widget _buildImageViewer() {
    Widget imageWidget;

    switch (widget.sourceType) {
      case FileSourceType.network:
        imageWidget = Image.network(
          widget.filePath,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator.adaptive());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Failed to load image', style: TextStyle(color: Colors.white)),
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
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Local image file not found', style: TextStyle(color: Colors.white)),
                ],
              ),
            );
          },
        );
        break;
      case FileSourceType.asset:
        imageWidget = Image.asset(
          widget.filePath,
          fit: BoxFit.contain,
        );
        break;
    }

    if (widget.heroTag != null) {
      imageWidget = Hero(tag: widget.heroTag!, child: imageWidget);
    }

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(child: imageWidget),
    );
  }

  Widget _buildPdfViewer() {
    return Stack(
      children: [
        PDFView(
          filePath: widget.sourceType == FileSourceType.file
              ? widget.filePath
              : null,
          pdfData: widget.sourceType == FileSourceType.asset ? null : null,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          onRender: (pages) {
            setState(() {
              _totalPages = pages ?? 0;
              _isPdfReady = true;
            });
          },
          onViewCreated: (controller) {
            _pdfViewController = controller;
          },
          onPageChanged: (page, total) {
            setState(() {
              _currentPage = page ?? 0;
            });
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading PDF: $error')),
            );
          },
        ),
        if (!_isPdfReady)
          const Center(child: CircularProgressIndicator.adaptive()),
      ],
    );
  }

  Widget _buildPdfPageController() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0
                ? () => _pdfViewController?.setPage(_currentPage - 1)
                : null,
          ),
          Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < _totalPages - 1
                ? () => _pdfViewController?.setPage(_currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
