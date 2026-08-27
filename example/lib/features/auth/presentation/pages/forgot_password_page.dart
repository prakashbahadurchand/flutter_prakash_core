import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/forgot_password/forgot_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/forgot_password/forgot_password_state.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_form_card.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_submit_button.dart';

@RoutePage()
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordCubit>(),
      child: const _ForgotPasswordForm(),
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: ReactiveFormListener<ForgotPasswordCubit, ForgotPasswordState>(
          successMessage: 'Reset code sent to your email!',
          onSuccess: (context, state) {
            context.router.push(ResetPasswordRoute(email: state.email.value));
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
                  const AuthHeader(
                    title: 'Forgot Password?',
                    subtitle:
                        'Enter your email address to receive a 6-digit password reset code.',
                    icon: Icons.mark_email_read_outlined,
                  ),
                  const SizedBox(height: 32),
                  CommonFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field (Rebuilds ONLY on email change)
                        BlocSelector<
                          ForgotPasswordCubit,
                          ForgotPasswordState,
                          Field<String>
                        >(
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
                        const SizedBox(height: 24),

                        // Submit Button (Rebuilds ONLY on loading status change)
                        BlocSelector<
                          ForgotPasswordCubit,
                          ForgotPasswordState,
                          bool
                        >(
                          selector: (state) => state.status.isLoading,
                          builder: (context, isLoading) {
                            return CommonSubmitButton(
                              isLoading: isLoading,
                              onPressed: cubit.submit,
                              label: 'Send Verification Code',
                            );
                          },
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
          ),
        ),
      ),
    );
  }
}
