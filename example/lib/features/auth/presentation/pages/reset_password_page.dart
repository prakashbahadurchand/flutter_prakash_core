import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/reset_password/reset_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/reset_password/reset_password_state.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';

@RoutePage()
class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String? otp;

  const ResetPasswordPage({super.key, required this.email, this.otp});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final ResetPasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ResetPasswordCubit>();
    _cubit.init(widget.email, defaultOtp: widget.otp);
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
          child: ReactiveFormListener<ResetPasswordCubit, ResetPasswordState>(
            successMessage: 'Password successfully reset! Please sign in.',
            onSuccess: (context, state) {
              context.router.replaceAll([const LoginRoute()]);
            },
            child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
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
                          title: 'Reset Password',
                          subtitle:
                              'Enter the 6-digit code sent to your email and your new password.',
                          icon: Icons.vpn_key_outlined,
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
                                field: state.otpCode,
                                onChanged: _cubit.onOtpChanged,
                                keyboardType: TextInputType.number,
                                prefixIcon: const Icon(Icons.pin_outlined),
                              ),
                              const SizedBox(height: 16),
                              ReactiveTextField(
                                field: state.newPassword,
                                onChanged: _cubit.onNewPasswordChanged,
                                obscureText: state.isNewPasswordObscured,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isNewPasswordObscured
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed:
                                      _cubit.toggleNewPasswordVisibility,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ReactiveTextField(
                                field: state.confirmPassword,
                                onChanged: _cubit.onConfirmPasswordChanged,
                                obscureText: state.isConfirmPasswordObscured,
                                prefixIcon:
                                    const Icon(Icons.lock_reset_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isConfirmPasswordObscured
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed:
                                      _cubit.toggleConfirmPasswordVisibility,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: state.status.isLoading
                                    ? null
                                    : () => _cubit.submit(),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: state.status.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Reset & Sign In',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ],
                          ),
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
