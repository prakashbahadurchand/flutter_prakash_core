import 'package:flutter/material.dart';

/// Options tabview placeholder for custom devtools options.
class DevtoolsCustomOptionsTabView extends StatelessWidget {
  const DevtoolsCustomOptionsTabView({super.key, this.title = 'Options'});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.tune, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Custom configuration options and feature toggles.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
