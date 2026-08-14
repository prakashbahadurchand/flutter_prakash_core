import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: August 2026\n\n'
              'Flutter Prakash takes your privacy seriously. We process data securely on-device with zero untracked data leaks. '
              'We do not collect personal information without your explicit consent.\n\n'
              '1. Data Collection\n'
              'We only collect data that is necessary for the core functionality of the application. '
              'This may include device information and crash reports to improve stability.\n\n'
              '2. Data Usage\n'
              'Your data is never sold to third parties. It is exclusively used to provide and improve the service.\n\n'
              '3. Security\n'
              'We implement industry-standard encryption to protect your data both in transit and at rest.\n\n'
              'If you have any questions about this Privacy Policy, please contact our support team.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
