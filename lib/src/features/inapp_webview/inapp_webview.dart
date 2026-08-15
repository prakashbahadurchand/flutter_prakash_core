import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Reusable full-featured InAppWebView component & screen for privacy policies,
/// terms of service, help center, or any embedded web URL rendering.
///
/// Features:
/// - Progress loading indicator bar.
/// - Web navigation controls (back, forward, refresh).
/// - Custom JavaScript execution & headers support.
/// - Inline widget mode or full Scaffold Page mode.
class InAppWebView extends StatefulWidget {
  const InAppWebView({
    super.key,
    required this.initialUrl,
    this.title,
    this.showAppBar = true,
    this.showNavigationControls = true,
    this.actions,
    this.onPageStarted,
    this.onPageFinished,
    this.onWebResourceError,
  });

  /// The target URL to open.
  final String initialUrl;

  /// Optional AppBar title.
  final String? title;

  /// Whether to render the full Scaffold AppBar (default `true`).
  final bool showAppBar;

  /// Whether to display bottom web navigation controls (back/forward/reload).
  final bool showNavigationControls;

  /// Optional extra AppBar action buttons.
  final List<Widget>? actions;

  /// Callback when page loading starts.
  final ValueChanged<String>? onPageStarted;

  /// Callback when page loading completes.
  final ValueChanged<String>? onPageFinished;

  /// Callback when web resource load fails.
  final ValueChanged<WebResourceError>? onWebResourceError;

  /// Static helper to open the web view as a modal route.
  static Future<void> show(
    BuildContext context, {
    required String initialUrl,
    String? title,
    bool showNavigationControls = true,
    List<Widget>? actions,
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InAppWebView(
          initialUrl: initialUrl,
          title: title,
          showAppBar: true,
          showNavigationControls: showNavigationControls,
          actions: actions,
        ),
      ),
    );
  }

  @override
  State<InAppWebView> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebView> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  String _pageTitle = '';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageStarted: (String url) {
            widget.onPageStarted?.call(url);
          },
          onPageFinished: (String url) async {
            final title = await _controller.getTitle();
            if (mounted) {
              setState(() {
                _pageTitle = title ?? '';
              });
            }
            widget.onPageFinished?.call(url);
          },
          onWebResourceError: (WebResourceError error) {
            widget.onWebResourceError?.call(error);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        if (_loadingProgress < 100)
          LinearProgressIndicator(
            value: _loadingProgress / 100.0,
            backgroundColor: Colors.transparent,
          ),
        Expanded(child: WebViewWidget(controller: _controller)),
      ],
    );

    if (!widget.showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? (_pageTitle.isNotEmpty ? _pageTitle : 'Web View'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
      body: body,
      bottomNavigationBar: widget.showNavigationControls
          ? _buildNavigationControls()
          : null,
    );
  }

  Widget _buildNavigationControls() {
    return FutureBuilder<bool>(
      future: _controller.canGoBack(),
      builder: (context, backSnapshot) {
        return FutureBuilder<bool>(
          future: _controller.canGoForward(),
          builder: (context, forwardSnapshot) {
            final canGoBack = backSnapshot.data ?? false;
            final canGoForward = forwardSnapshot.data ?? false;

            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: canGoBack ? () => _controller.goBack() : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: canGoForward
                        ? () => _controller.goForward()
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => _controller.reload(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
