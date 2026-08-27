import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/email_verification/email_verification_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/email_verification/email_verification_state.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';

@RoutePage()
class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late final EmailVerificationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<EmailVerificationCubit>();
    _cubit.init(widget.email);
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
            child:
                BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  context.router.replaceAll([const DashboardRoute()]);
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
                        AuthHeader(
                          title: 'Verify Your Email',
                          subtitle:
                              'We have sent a 6-digit verification code to\n${widget.email}',
                          icon: Icons.verified_user_outlined,
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
                              ReactivePinCodeField(
                                field: state.otpCode,
                                onChanged: _cubit.otpChanged,
                                length: 6,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: state.isInProgress
                                    ? null
                                    : () => _cubit.verifyCode(),
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
                                        'Verify & Continue',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: state.canResend
                                    ? TextButton(
                                        onPressed: () => _cubit.resendCode(),
                                        child: const Text(
                                          'Resend Code',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'Resend code in ${state.resendCountdown}s',
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                          fontSize: 13,
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
