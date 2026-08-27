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
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _RegisterForm(),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: ReactiveFormListener<RegisterCubit, RegisterState>(
          successMessage: 'Account created successfully!',
          onSuccess: (context, state) {
            context.router.push(
              EmailVerificationRoute(email: state.email.value),
            );
          },
          child: Center(
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

                  // Registration Form Card
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
                        // Full Name Field (Rebuilds ONLY on fullName change)
                        BlocSelector<RegisterCubit, RegisterState,
                            Field<String>>(
                          selector: (state) => state.fullName,
                          builder: (context, fullName) {
                            return ReactiveTextField(
                              field: fullName,
                              onChanged: cubit.onFullNameChanged,
                              prefixIcon: const Icon(Icons.person_outline),
                            );
                          },
                        ),
                        const SizedBox(height: 14),

                        // Email Field (Rebuilds ONLY on email change)
                        BlocSelector<RegisterCubit, RegisterState,
                            Field<String>>(
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
                        const SizedBox(height: 14),

                        // Password Field (Rebuilds ONLY on password/obscure change)
                        BlocSelector<RegisterCubit, RegisterState,
                            (Field<String>, bool)>(
                          selector: (state) =>
                              (state.password, state.isPasswordObscured),
                          builder: (context, data) {
                            final (password, isObscured) = data;
                            return ReactiveTextField(
                              field: password,
                              onChanged: cubit.onPasswordChanged,
                              obscureText: isObscured,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: cubit.togglePasswordVisibility,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 14),

                        // Confirm Password Field (Rebuilds ONLY on confirmPassword/obscure change)
                        BlocSelector<RegisterCubit, RegisterState,
                            (Field<String>, bool)>(
                          selector: (state) => (
                            state.confirmPassword,
                            state.isConfirmPasswordObscured
                          ),
                          builder: (context, data) {
                            final (confirmPassword, isObscured) = data;
                            return ReactiveTextField(
                              field: confirmPassword,
                              onChanged: cubit.onConfirmPasswordChanged,
                              obscureText: isObscured,
                              prefixIcon:
                                  const Icon(Icons.lock_reset_outlined),
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
                        const SizedBox(height: 12),

                        // Agree to Terms Checkbox (Rebuilds ONLY on agreeToTerms change)
                        BlocSelector<RegisterCubit, RegisterState, bool>(
                          selector: (state) => state.agreeToTerms.value,
                          builder: (context, agreeToTerms) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: agreeToTerms,
                                    onChanged: cubit.onAgreeToTermsChanged,
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
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Submit Button (Rebuilds ONLY on loading change)
                        BlocSelector<RegisterCubit, RegisterState, bool>(
                          selector: (state) => state.status.isLoading,
                          builder: (context, isLoading) {
                            return ElevatedButton(
                              onPressed: isLoading ? null : cubit.submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: isLoading
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
                            );
                          },
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
          ),
        ),
      ),
    );
  }
}
