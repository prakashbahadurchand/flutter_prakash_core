import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Reusable full-featured InAppWebView Container and Page component for enterprise apps.
///
/// Features:
/// - Smooth progress loading indicator bar with customizable colors.
/// - Web navigation controls (back, forward, reload) with customizable themes.
/// - JavaScript execution mode & custom headers support.
/// - Embeddable inline Widget container or full Scaffold page mode.
/// - Custom error handling, loading builder, and lifecycle callbacks.
///
/// ---
///
/// ### 📖 Easy Usage Examples:
///
/// #### 1. Open as a Full Screen Modal Route:
/// ```dart
/// // Open Privacy Policy / Help Center:
/// InAppWebViewContainer.show(
///   context,
///   initialUrl: 'https://example.com/privacy-policy',
///   title: 'Privacy Policy',
///   progressBarColor: Colors.blueAccent,
/// );
///
/// // Open External Web Portal with Custom Headers & Theming:
/// InAppWebViewContainer.show(
///   context,
///   initialUrl: 'https://dashboard.example.com',
///   headers: {'Authorization': 'Bearer $token'},
///   appBarBackgroundColor: Colors.teal,
///   controlsBackgroundColor: Colors.teal.shade50,
/// );
/// ```
///
/// #### 2. Create a Dedicated Custom Screen / Page:
/// ```dart
/// class TermsAndConditionsPage extends StatelessWidget {
///   const TermsAndConditionsPage({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return InAppWebViewContainer(
///       initialUrl: 'https://example.com/terms',
///       title: 'Terms of Service',
///       actions: [
///         IconButton(
///           icon: const Icon(Icons.share),
///           onPressed: () => shareUrl('https://example.com/terms'),
///         ),
///       ],
///     );
///   }
/// }
/// ```
///
/// #### 3. Embed Directly as an Inline Widget Container:
/// ```dart
/// class EmbeddedWebBanner extends StatelessWidget {
///   const EmbeddedWebBanner({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return ClipRRect(
///       borderRadius: BorderRadius.circular(16),
///       child: SizedBox(
///         height: 300,
///         child: InAppWebViewContainer(
///           initialUrl: 'https://flutter.dev',
///           showAppBar: false, // Disables AppBar for embedded containers
///           showNavigationControls: false,
///         ),
///       ),
///     );
///   }
/// }
/// ```
class InAppWebViewContainer extends StatefulWidget {
  const InAppWebViewContainer({
    super.key,
    required this.initialUrl,
    this.title,
    this.showAppBar = true,
    this.showNavigationControls = true,
    this.actions,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.progressBarColor,
    this.controlsBackgroundColor,
    this.controlsForegroundColor,
    this.javascriptMode = JavaScriptMode.unrestricted,
    this.headers = const {},
    this.loadingWidget,
    this.errorWidgetBuilder,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
  });

  /// The target URL to load.
  final String initialUrl;

  /// Optional AppBar title. If null, displays the active webpage title.
  final String? title;

  /// Whether to render the full Scaffold AppBar (default `true`). Set to `false` when embedding as a container.
  final bool showAppBar;

  /// Whether to display bottom web navigation controls (back/forward/reload).
  final bool showNavigationControls;

  /// Optional custom action buttons in the AppBar.
  final List<Widget>? actions;

  /// Custom background color of the webview container/scaffold.
  final Color? backgroundColor;

  /// Custom background color for the AppBar.
  final Color? appBarBackgroundColor;

  /// Custom icon/text color for the AppBar.
  final Color? appBarForegroundColor;

  /// Custom color for the linear progress bar.
  final Color? progressBarColor;

  /// Custom background color for the bottom navigation bar.
  final Color? controlsBackgroundColor;

  /// Custom icon color for the bottom navigation bar.
  final Color? controlsForegroundColor;

  /// JavaScript execution mode. Defaults to [JavaScriptMode.unrestricted].
  final JavaScriptMode javascriptMode;

  /// Additional HTTP headers to pass when loading the initial URL.
  final Map<String, String> headers;

  /// Custom loading widget displayed during initial load.
  final Widget? loadingWidget;

  /// Custom error builder when web resource fails to load.
  final Widget Function(BuildContext context, WebResourceError error)?
  errorWidgetBuilder;

  /// Callback when page starts loading.
  final ValueChanged<String>? onPageStarted;

  /// Callback when page finishes loading.
  final ValueChanged<String>? onPageFinished;

  /// Callback when page loading progress updates (0 to 100).
  final ValueChanged<int>? onProgress;

  /// Callback when a web resource fails to load.
  final ValueChanged<WebResourceError>? onWebResourceError;

  /// Static helper to launch the [InAppWebViewContainer] as a full modal route.
  static Future<T?> show<T>(
    BuildContext context, {
    required String initialUrl,
    String? title,
    bool showAppBar = true,
    bool showNavigationControls = true,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? appBarBackgroundColor,
    Color? appBarForegroundColor,
    Color? progressBarColor,
    Color? controlsBackgroundColor,
    Color? controlsForegroundColor,
    JavaScriptMode javascriptMode = JavaScriptMode.unrestricted,
    Map<String, String> headers = const {},
    Widget? loadingWidget,
    Widget Function(BuildContext context, WebResourceError error)?
    errorWidgetBuilder,
    ValueChanged<String>? onPageStarted,
    ValueChanged<String>? onPageFinished,
    ValueChanged<int>? onProgress,
    ValueChanged<WebResourceError>? onWebResourceError,
    bool useRootNavigator = true,
  }) {
    return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
      MaterialPageRoute<T>(
        builder: (_) => InAppWebViewContainer(
          initialUrl: initialUrl,
          title: title,
          showAppBar: showAppBar,
          showNavigationControls: showNavigationControls,
          actions: actions,
          backgroundColor: backgroundColor,
          appBarBackgroundColor: appBarBackgroundColor,
          appBarForegroundColor: appBarForegroundColor,
          progressBarColor: progressBarColor,
          controlsBackgroundColor: controlsBackgroundColor,
          controlsForegroundColor: controlsForegroundColor,
          javascriptMode: javascriptMode,
          headers: headers,
          loadingWidget: loadingWidget,
          errorWidgetBuilder: errorWidgetBuilder,
          onPageStarted: onPageStarted,
          onPageFinished: onPageFinished,
          onProgress: onProgress,
          onWebResourceError: onWebResourceError,
        ),
      ),
    );
  }

  @override
  State<InAppWebViewContainer> createState() => _InAppWebViewContainerState();
}

class _InAppWebViewContainerState extends State<InAppWebViewContainer> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  String _pageTitle = '';
  WebResourceError? _lastError;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    unawaited(_controller.setJavaScriptMode(widget.javascriptMode));
    unawaited(
      _controller.setBackgroundColor(
        widget.backgroundColor ?? Colors.transparent,
      ),
    );
    unawaited(
      _controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
            widget.onProgress?.call(progress);
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _lastError = null;
              });
            }
            widget.onPageStarted?.call(url);
          },
          onPageFinished: (String url) async {
            final pageTitle = await _controller.getTitle();
            if (mounted) {
              setState(() {
                _pageTitle = pageTitle ?? '';
              });
            }
            widget.onPageFinished?.call(url);
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _lastError = error;
              });
            }
            widget.onWebResourceError?.call(error);
          },
        ),
      ),
    );
    unawaited(
      _controller.loadRequest(
        Uri.parse(widget.initialUrl),
        headers: widget.headers,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBg = widget.backgroundColor ?? theme.scaffoldBackgroundColor;

    Widget bodyContent;
    if (_lastError != null && widget.errorWidgetBuilder != null) {
      bodyContent = widget.errorWidgetBuilder!(context, _lastError!);
    } else {
      bodyContent = Column(
        children: [
          if (_loadingProgress < 100)
            LinearProgressIndicator(
              value: _loadingProgress / 100.0,
              backgroundColor: Colors.transparent,
              valueColor: widget.progressBarColor != null
                  ? AlwaysStoppedAnimation<Color>(widget.progressBarColor!)
                  : null,
            ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loadingProgress < 60 && widget.loadingWidget != null)
                  Center(child: widget.loadingWidget),
              ],
            ),
          ),
        ],
      );
    }

    if (!widget.showAppBar) {
      return Container(
        color: effectiveBg,
        child: Column(
          children: [
            Expanded(child: bodyContent),
            if (widget.showNavigationControls)
              _buildNavigationControls(context),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: effectiveBg,
      appBar: AppBar(
        title: Text(
          widget.title ?? (_pageTitle.isNotEmpty ? _pageTitle : 'Web View'),
        ),
        backgroundColor: widget.appBarBackgroundColor,
        foregroundColor: widget.appBarForegroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
      body: bodyContent,
      bottomNavigationBar: widget.showNavigationControls
          ? _buildNavigationControls(context)
          : null,
    );
  }

  Widget _buildNavigationControls(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor =
        widget.controlsBackgroundColor ??
        theme.colorScheme.surfaceContainerHighest;
    final fgColor =
        widget.controlsForegroundColor ?? theme.colorScheme.onSurface;

    return FutureBuilder<bool>(
      future: _controller.canGoBack(),
      builder: (context, backSnapshot) {
        return FutureBuilder<bool>(
          future: _controller.canGoForward(),
          builder: (context, forwardSnapshot) {
            final canGoBack = backSnapshot.data ?? false;
            final canGoForward = forwardSnapshot.data ?? false;

            return Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: fgColor),
                    onPressed: canGoBack ? () => _controller.goBack() : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: fgColor),
                    onPressed: canGoForward
                        ? () => _controller.goForward()
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: fgColor),
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

/// Backward compatibility alias for [InAppWebViewContainer].
typedef InAppWebView = InAppWebViewContainer;

/// Backward compatibility alias for [InAppWebViewContainer].
typedef InAppWebViewPage = InAppWebViewContainer;
