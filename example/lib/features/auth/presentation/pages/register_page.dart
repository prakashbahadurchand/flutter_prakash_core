import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/register/register_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/register/register_state.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_divider.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_footer.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_social_buttons.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<RegisterCubit>();
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: BlocProvider.value(
          value: _cubit,
          child: ReactiveFormListener<RegisterCubit, RegisterState>(
            successMessage: 'Account created successfully!',
            onSuccess: (context, state) {
              context.router.push(
                EmailVerificationRoute(email: state.email.value),
              );
            },
            child: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthHeader(
                          title: 'Create Account',
                          subtitle: 'Join us and start building enterprise apps',
                          icon: Icons.person_add_outlined,
                        ),
                        const SizedBox(height: 28),

                        // Registration form card
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
                                field: state.fullName,
                                onChanged: _cubit.onFullNameChanged,
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              const SizedBox(height: 14),
                              ReactiveTextField(
                                field: state.email,
                                onChanged: _cubit.onEmailChanged,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              const SizedBox(height: 14),
                              ReactiveTextField(
                                field: state.password,
                                onChanged: _cubit.onPasswordChanged,
                                obscureText: state.isPasswordObscured,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    state.isPasswordObscured
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: _cubit.togglePasswordVisibility,
                                ),
                              ),
                              const SizedBox(height: 14),
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
                              const SizedBox(height: 12),

                              // Agree to Terms
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: state.agreeToTerms.value,
                                      onChanged: _cubit.onAgreeToTermsChanged,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Text(
                                          'I agree to the ',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        InkWell(
                                          onTap: () => context.router.push(
                                            const TermsAndConditionsRoute(),
                                          ),
                                          child: const Text(
                                            'Terms',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppPalette.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          ' & ',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        InkWell(
                                          onTap: () => context.router.push(
                                            const PrivacyPolicyRoute(),
                                          ),
                                          child: const Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppPalette.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Submit Button
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
                                        'Create Account',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        const AuthDivider(),
                        const SizedBox(height: 16),
                        const AuthSocialButtons(),
                        const SizedBox(height: 24),

                        AuthFooter(
                          prompt: 'Already have an account?',
                          actionLabel: 'Sign In',
                          onAction: () => context.router.maybePop(),
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
