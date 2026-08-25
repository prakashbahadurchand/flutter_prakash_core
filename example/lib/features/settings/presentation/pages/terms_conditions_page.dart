import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Last updated: August 2026\n\n'
              'Please read these Terms of Service carefully before using the Flutter Prakash application.\n\n'
              '1. Acceptance of Terms\n'
              'By accessing or using the application, you agree to be bound by these Terms. '
              'If you disagree with any part of the terms, you do not have permission to access the service.\n\n'
              '2. License Use\n'
              'We grant you a personal, non-exclusive, non-transferable, limited privilege to enter and use the Application. '
              'You may not modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell any information, software, products or services obtained from the Application.\n\n'
              '3. Disclaimer\n'
              'The materials on the application are provided on an "as is" basis. '
              'We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.\n\n'
              '4. Limitations\n'
              'In no event shall Flutter Prakash or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on the application.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
