import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final ForgotPasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ForgotPasswordCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: BlocProvider.value(
          value: _cubit,
          child: PrakashEffectListener.fromCubit(
            cubit: _cubit,
            child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  context.router.push(
                    ResetPasswordRoute(email: state.email.value),
                  );
                }
              },
              builder: (context, state) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthHeader(
                          title: 'Forgot Password?',
                          subtitle:
                              'Enter your email address to receive a 6-digit password reset code.',
                          icon: Icons.mark_email_read_outlined,
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppPalette.surface(isDark),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ReactiveTextField(
                                field: state.email,
                                onChanged: _cubit.emailChanged,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: state.isInProgress
                                    ? null
                                    : () => _cubit.sendResetCode(),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: state.isInProgress
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Send Verification Code',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton.icon(
                          onPressed: () => context.router.maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Back to Sign In'),
                        ),
                      ],
                    ),
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
