import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/legal_cubit.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/legal_state.dart';

@RoutePage()
class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LegalCubit>()..loadTermsAndConditions(),
      child: const _TermsAndConditionsView(),
    );
  }
}

class _TermsAndConditionsView extends StatelessWidget {
  const _TermsAndConditionsView();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service'), centerTitle: true),
      body: BlocBuilder<LegalCubit, LegalState>(
        builder: (context, state) {
          return switch (state) {
            LegalInitial() ||
            LegalLoading() =>
              const Center(child: CircularProgressIndicator()),
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
    );
  }
}
