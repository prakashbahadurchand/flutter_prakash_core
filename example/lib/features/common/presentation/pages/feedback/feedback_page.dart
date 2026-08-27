import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/feedback_cubit.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/blocs/feedback_state.dart';

@RoutePage()
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late final FeedbackCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<FeedbackCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Send Feedback'), centerTitle: true),
      body: SafeArea(
        child: BlocProvider.value(
          value: _cubit,
          child: ReactiveFormListener<FeedbackCubit, FeedbackState>(
            successMessage: 'Thank you! Your feedback has been sent.',
            onSuccess: (context, state) {
              context.router.maybePop();
            },
            child: BlocBuilder<FeedbackCubit, FeedbackState>(
              builder: (context, state) {
                return SingleChildScrollView(
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
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
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
                            ReactiveTextField(
                              field: state.email,
                              onChanged: _cubit.onEmailChanged,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            const SizedBox(height: 16),
                            ReactiveTextField(
                              field: state.feedback,
                              onChanged: _cubit.onFeedbackChanged,
                              maxLines: 5,
                              prefixIcon: const Icon(Icons.feedback_outlined),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: state.status.isLoading
                            ? null
                            : () => _cubit.submit(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: state.status.isLoading
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
