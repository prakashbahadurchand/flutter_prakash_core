import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';

@RoutePage()
class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Real-Time Analytics',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Chip(
                avatar: const Icon(Icons.circle, size: 10, color: Colors.green),
                label: const Text('Live Stream'),
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                side: BorderSide.none,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart Card Placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Traffic Distribution',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart, size: 36, color: Colors.indigo),
                          SizedBox(width: 8),
                          Text('Analytics Chart View (fl_chart or similar)'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Traffic Sources Breakdown
          ResponsiveBuilder(
            mobile: (context) => Column(
              children: const [
                _AnalyticsMetricTile(
                  label: 'Direct Traffic',
                  percent: 0.45,
                  color: Colors.blue,
                ),
                SizedBox(height: 12),
                _AnalyticsMetricTile(
                  label: 'Search Engines',
                  percent: 0.35,
                  color: Colors.green,
                ),
                SizedBox(height: 12),
                _AnalyticsMetricTile(
                  label: 'Social Referrals',
                  percent: 0.20,
                  color: Colors.orange,
                ),
              ],
            ),
            desktop: (context) => Row(
              children: const [
                Expanded(
                  child: _AnalyticsMetricTile(
                    label: 'Direct Traffic',
                    percent: 0.45,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _AnalyticsMetricTile(
                    label: 'Search Engines',
                    percent: 0.35,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _AnalyticsMetricTile(
                    label: 'Social Referrals',
                    percent: 0.20,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsMetricTile extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const _AnalyticsMetricTile({
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percent,
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${(percent * 100).toInt()}% Total Traffic',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
