import 'package:flutter/material.dart';

/// GraphQL Inspector tabview placeholder widget for GraphQL network operations.
class DevtoolsGraphqlInspectorTabView extends StatelessWidget {
  const DevtoolsGraphqlInspectorTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.graphic_eq, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              'GraphQL Inspector',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Inspect GraphQL queries, mutations, subscriptions and payloads.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
