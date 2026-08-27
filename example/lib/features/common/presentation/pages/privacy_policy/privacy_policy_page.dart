import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/legal_cubit.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/legal_state.dart';

@RoutePage()
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final LegalCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<LegalCubit>();
    _cubit.loadPrivacyPolicy();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy'), centerTitle: true),
      body: BlocProvider.value(
        value: _cubit,
        child: BlocBuilder<LegalCubit, LegalState>(
          builder: (context, state) {
            return switch (state) {
              LegalInitial() || LegalLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              LegalFailure(message: final msg) => Center(
                  child: Text(msg, style: const TextStyle(color: Colors.red)),
                ),
              LegalLoaded(document: final doc) => SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${doc.lastUpdated}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        doc.content,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
