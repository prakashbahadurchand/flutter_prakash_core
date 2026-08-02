import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class PrakashImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? fallbackAsset;

  const PrakashImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => ShimmerBox(width: width, height: height),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      );
    } else if (imagePath.endsWith('.svg')) {
      return SvgPicture.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Image.asset(imagePath, width: width, height: height, fit: fit);
    }
  }

  Widget _buildErrorWidget() {
    if (fallbackAsset != null) {
      return Image.asset(
        fallbackAsset!,
        width: width,
        height: height,
        fit: fit,
      );
    }
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A scroll-driven paginated list.
///
/// Pairs a [fetchPage] function with [itemBuilder]. Automatically fetches the
/// next page when the scroll reaches the end, and handles loading, empty and
/// error states. Fully self-contained and framework-agnostic.
class PrakashPaginatedList<T> extends StatefulWidget {
  final Future<PageResult<T>> Function(int pageKey) fetchPage;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? firstPageIndicator;
  final Widget? emptyPage;

  const PrakashPaginatedList({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    this.firstPageIndicator,
    this.emptyPage,
  });

  @override
  State<PrakashPaginatedList<T>> createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PrakashPaginatedList<T>> {
  final ScrollController _scrollController = ScrollController();
  final List<T> _items = [];
  int _nextPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _refresh();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore || _hasError) return;
    setState(() => _isLoading = true);
    try {
      final page = await widget.fetchPage(_nextPage);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _hasMore = _nextPage < page.totalPages;
        _nextPage++;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _refresh() {
    setState(() {
      _items.clear();
      _nextPage = 1;
      _hasMore = true;
      _hasError = false;
    });
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _items.isEmpty && !_hasError) {
      return widget.firstPageIndicator ??
          const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
    }

    if (_items.isEmpty && _hasError) {
      return _ErrorView(onRetry: _refresh);
    }

    if (_items.isEmpty && !_hasMore) {
      return widget.emptyPage ?? const SizedBox(height: 200);
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: _items.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index >= _items.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return widget.itemBuilder(context, _items[index], index);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

/// Result envelope returned by a page-fetch function.
class PageResult<T> {
  const PageResult({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<T> items;
  final int page;
  final int totalPages;
}

class _ErrorView extends StatelessWidget {
  final VoidCallback? onRetry;
  const _ErrorView({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 48),
          const SizedBox(height: 8),
          const Text('Something went wrong. Please retry.'),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
