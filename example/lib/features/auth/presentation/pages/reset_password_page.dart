import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/reset_password/reset_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/reset_password/reset_password_state.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_form_card.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_submit_button.dart';

@RoutePage()
class ResetPasswordPage extends StatelessWidget {
  final String email;
  final String? otp;

  const ResetPasswordPage({super.key, required this.email, this.otp});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ResetPasswordCubit>()..init(email, defaultOtp: otp),
      child: const _ResetPasswordForm(),
    );
  }
}

class _ResetPasswordForm extends StatelessWidget {
  const _ResetPasswordForm();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResetPasswordCubit>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: ReactiveFormListener<ResetPasswordCubit, ResetPasswordState>(
          successMessage: 'Password successfully reset! Please sign in.',
          onSuccess: (context, state) {
            context.router.replaceAll([const LoginRoute()]);
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
                    title: 'Reset Password',
                    subtitle:
                        'Enter the 6-digit code sent to your email and your new password.',
                    icon: Icons.vpn_key_outlined,
                  ),
                  const SizedBox(height: 32),
                  CommonFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // OTP Code Field (Rebuilds ONLY on otpCode changes)
                        BlocSelector<
                          ResetPasswordCubit,
                          ResetPasswordState,
                          Field<String>
                        >(
                          selector: (state) => state.otpCode,
                          builder: (context, otpCode) {
                            return ReactiveTextField(
                              field: otpCode,
                              onChanged: cubit.onOtpChanged,
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(Icons.pin_outlined),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // New Password Field (Rebuilds ONLY on newPassword/obscure changes)
                        BlocSelector<
                          ResetPasswordCubit,
                          ResetPasswordState,
                          (Field<String>, bool)
                        >(
                          selector: (state) =>
                              (state.newPassword, state.isNewPasswordObscured),
                          builder: (context, data) {
                            final (newPassword, isObscured) = data;
                            return ReactiveTextField(
                              field: newPassword,
                              onChanged: cubit.onNewPasswordChanged,
                              obscureText: isObscured,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: cubit.toggleNewPasswordVisibility,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Field (Rebuilds ONLY on confirmPassword/obscure changes)
                        BlocSelector<
                          ResetPasswordCubit,
                          ResetPasswordState,
                          (Field<String>, bool)
                        >(
                          selector: (state) => (
                            state.confirmPassword,
                            state.isConfirmPasswordObscured,
                          ),
                          builder: (context, data) {
                            final (confirmPassword, isObscured) = data;
                            return ReactiveTextField(
                              field: confirmPassword,
                              onChanged: cubit.onConfirmPasswordChanged,
                              obscureText: isObscured,
                              prefixIcon: const Icon(Icons.lock_reset_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed:
                                    cubit.toggleConfirmPasswordVisibility,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Submit Button (Rebuilds ONLY on loading status changes)
                        BlocSelector<
                          ResetPasswordCubit,
                          ResetPasswordState,
                          bool
                        >(
                          selector: (state) => state.status.isLoading,
                          builder: (context, isLoading) {
                            return CommonSubmitButton(
                              isLoading: isLoading,
                              onPressed: cubit.submit,
                              label: 'Reset & Sign In',
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
