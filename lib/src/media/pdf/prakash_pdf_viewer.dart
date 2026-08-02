import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

/// PDF renderer widget with a built-in loading indicator, page counter and
/// error state view, wrapping `flutter_pdfview`.
class PrakashPdfViewer extends StatefulWidget {
  /// Absolute file path to the PDF document.
  final String filePath;
  final bool enableSwipe;
  final bool swipeHorizontal;
  final bool autoSpacing;
  final bool pageFling;

  const PrakashPdfViewer({
    super.key,
    required this.filePath,
    this.enableSwipe = true,
    this.swipeHorizontal = true,
    this.autoSpacing = false,
    this.pageFling = false,
  });

  @override
  State<PrakashPdfViewer> createState() => _PrakashPdfViewerState();
}

class _PrakashPdfViewerState extends State<PrakashPdfViewer> {
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 0;
  int? _totalPages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PDFView(
                filePath: widget.filePath,
                enableSwipe: widget.enableSwipe,
                swipeHorizontal: widget.swipeHorizontal,
                autoSpacing: widget.autoSpacing,
                pageFling: widget.pageFling,
                onRender: (pages) {
                  setState(() {
                    _totalPages = pages;
                    _isLoading = false;
                  });
                },
                onError: (error) {
                  setState(() {
                    _hasError = true;
                    _isLoading = false;
                  });
                },
                onPageChanged: (page, total) {
                  setState(() {
                    _currentPage = page ?? 0;
                    _totalPages = total;
                  });
                },
              ),
              if (_isLoading) const CircularProgressIndicator(),
              if (_hasError)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.picture_as_pdf,
                        size: 56,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      const Text('Failed to render PDF'),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_totalPages != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Page ${_currentPage + 1} of $_totalPages',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
      ],
    );
  }
}
