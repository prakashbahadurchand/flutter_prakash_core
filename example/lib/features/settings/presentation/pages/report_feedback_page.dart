import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/core/di/injection.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/feedback_cubit.dart';
import 'package:flutter_prakash_core_example/features/settings/presentation/blocs/feedback_state.dart';

@RoutePage()
class ReportFeedbackPage extends StatefulWidget {
  const ReportFeedbackPage({super.key});

  @override
  State<ReportFeedbackPage> createState() => _ReportFeedbackPageState();
}

class _ReportFeedbackPageState extends State<ReportFeedbackPage> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Report Feedback'), centerTitle: true),
      body: BlocProvider.value(
        value: _cubit,
        child: PrakashEffectListener.fromCubit(
          cubit: _cubit,
          child: BlocBuilder<FeedbackCubit, FeedbackState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We value your feedback',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please let us know how we can improve your experience or report any issues you\'ve encountered.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ReactiveTextField(
                      field: state.feedback,
                      onChanged: _cubit.onFeedbackChanged,
                      maxLines: 6,
                      hintText: 'Type your feedback here...',
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: state.isInProgress
                            ? null
                            : () async {
                                await _cubit.submit();
                                if (context.mounted && state.isValid) {
                                  context.router.maybePop();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: state.isInProgress
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
