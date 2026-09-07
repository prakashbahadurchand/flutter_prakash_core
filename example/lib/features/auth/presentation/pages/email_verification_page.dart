import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/email_verification/email_verification_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/email_verification/email_verification_state.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_form_card.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_submit_button.dart';

@RoutePage()
class EmailVerificationPage extends StatelessWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EmailVerificationCubit>()..init(email),
      child: _EmailVerificationForm(email: email),
    );
  }
}

class _EmailVerificationForm extends StatelessWidget {
  final String email;

  const _EmailVerificationForm({required this.email});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<EmailVerificationCubit>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: ReactiveFormListener<EmailVerificationCubit, EmailVerificationState>(
          successMessage: 'Email successfully verified!',
          onSuccess: (context, state) {
            context.router.replaceAll([const DashboardRoute()]);
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    title: 'Verify Your Email',
                    subtitle:
                        'We have sent a 6-digit verification code to\n$email',
                    icon: Icons.verified_user_outlined,
                  ),
                  const SizedBox(height: 32),
                  CommonFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // OTP Code Field (Rebuilds ONLY on otpCode changes)
                        BlocSelector<
                          EmailVerificationCubit,
                          EmailVerificationState,
                          Field<String>
                        >(
                          selector: (state) => state.otpCode,
                          builder: (context, otpCode) {
                            return ReactivePinCodeField(
                              field: otpCode,
                              onChanged: cubit.onOtpChanged,
                              length: 6,
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Submit Button (Rebuilds ONLY on loading status change)
                        BlocSelector<
                          EmailVerificationCubit,
                          EmailVerificationState,
                          bool
                        >(
                          selector: (state) => state.status.isLoading,
                          builder: (context, isLoading) {
                            return CommonSubmitButton(
                              isLoading: isLoading,
                              onPressed: cubit.submit,
                              label: 'Verify & Continue',
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Resend Countdown Timer (Rebuilds ONLY on resend state change)
                        BlocSelector<
                          EmailVerificationCubit,
                          EmailVerificationState,
                          (bool, int)
                        >(
                          selector: (state) =>
                              (state.canResend, state.resendCountdown),
                          builder: (context, resendData) {
                            final (canResend, countdown) = resendData;
                            return Center(
                              child: canResend
                                  ? TextButton(
                                      onPressed: cubit.resendCode,
                                      child: const Text(
                                        'Resend Code',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Resend code in ${countdown}s',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
