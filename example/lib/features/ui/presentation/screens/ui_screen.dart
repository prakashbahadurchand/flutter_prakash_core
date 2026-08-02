import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

import '../../../../shared/widgets/wrappers.dart';

/// Presents the UI Design System feature.
///
/// Clean Architecture **presentation** layer.
class UiScreen extends StatefulWidget {
  const UiScreen({super.key});

  @override
  State<UiScreen> createState() => _UiScreenState();
}

class _UiScreenState extends State<UiScreen> {
  Future<PageResult<String>> _fetchPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final start = (page - 1) * 12;
    return PageResult<String>(
      items: [for (var i = 0; i < 12; i++) 'Sample item ${start + i + 1}'],
      page: page,
      totalPages: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DemoScaffold(
      title: 'UI Design System',
      child: Column(
        children: [
          DemoCard(
            title: 'Design Tokens',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TokenChip(
                  label: 'Spacing',
                  color: scheme.primary,
                  meta: 'xs-md-lg',
                ),
                _TokenChip(
                  label: 'Radius',
                  color: scheme.secondary,
                  meta: 'round',
                ),
                _TokenChip(
                  label: 'Elevation',
                  color: scheme.tertiary,
                  meta: 'low',
                ),
              ],
            ),
          ),
          DemoCard(
            title: 'Universal Image Loader',
            child: Column(
              children: [
                const PrakashImage(
                  imagePath: 'https://picsum.photos/400/150',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  'Auto placeholder shimmer + error fallback.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          DemoCard(
            title: 'QR Generator',
            child: Center(
              child: QRService.render(
                'https://flutter.dev',
                size: 160,
                color: scheme.primary,
              ),
            ),
          ),
          DemoCard(
            title: 'Shimmer Skeleton',
            child: Row(
              children: [
                const ShimmerBox(width: 56, height: 56, borderRadius: 12),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: 180, height: 14),
                      SizedBox(height: 8),
                      ShimmerBox(width: 120, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DemoCard(
            title: 'Paged List (infinite scroll)',
            child: SizedBox(
              height: 260,
              child: PrakashPaginatedList<String>(
                fetchPage: _fetchPage,
                itemBuilder: (context, item, index) => ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(item),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenChip extends StatelessWidget {
  final String label;
  final String meta;
  final Color color;

  const _TokenChip({
    required this.label,
    required this.meta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color, radius: 6),
      label: Text('$label · $meta'),
    );
  }
}