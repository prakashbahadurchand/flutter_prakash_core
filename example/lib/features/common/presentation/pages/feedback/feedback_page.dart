import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/feedback_cubit.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/feedback_state.dart';

@RoutePage()
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeedbackCubit>(),
      child: const _FeedbackForm(),
    );
  }
}

class _FeedbackForm extends StatelessWidget {
  const _FeedbackForm();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final cubit = context.read<FeedbackCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Send Feedback'), centerTitle: true),
      body: SafeArea(
        child: ReactiveFormListener<FeedbackCubit, FeedbackState>(
          successMessage: 'Thank you! Your feedback has been sent.',
          onSuccess: (context, state) {
            context.router.maybePop();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'We value your feedback',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Let us know what you think, report bugs, or request new features.',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppPalette.surface(isDark),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Email Field (Rebuilds ONLY on email change)
                      BlocSelector<FeedbackCubit, FeedbackState, Field<String>>(
                        selector: (state) => state.email,
                        builder: (context, email) {
                          return ReactiveTextField(
                            field: email,
                            onChanged: cubit.onEmailChanged,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Feedback Field (Rebuilds ONLY on feedback change)
                      BlocSelector<FeedbackCubit, FeedbackState, Field<String>>(
                        selector: (state) => state.feedback,
                        builder: (context, feedback) {
                          return ReactiveTextField(
                            field: feedback,
                            onChanged: cubit.onFeedbackChanged,
                            maxLines: 5,
                            prefixIcon: const Icon(Icons.feedback_outlined),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button (Rebuilds ONLY on loading status change)
                BlocSelector<FeedbackCubit, FeedbackState, bool>(
                  selector: (state) => state.status.isLoading,
                  builder: (context, isLoading) {
                    return ElevatedButton(
                      onPressed: isLoading ? null : cubit.submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Submit Feedback',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
