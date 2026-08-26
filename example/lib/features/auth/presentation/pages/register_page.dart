import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/core/di/injection.dart';
import 'package:flutter_prakash_example/core/router/app_router.dart';
import 'package:flutter_prakash_example/core/themes/app_colors.dart';
import 'package:flutter_prakash_example/features/auth/presentation/blocs/register/register_cubit.dart';
import 'package:flutter_prakash_example/features/auth/presentation/blocs/register/register_state.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterCubit _registerCubit;

  @override
  void initState() {
    super.initState();
    _registerCubit = getIt<RegisterCubit>();
  }

  @override
  void dispose() {
    _registerCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider.value(
        value: _registerCubit,
        child: ReactiveFormListener<RegisterCubit, RegisterState>(
          successMessage: 'Account created successfully! Welcome aboard.',
          onSuccess: (context, state) {
            context.router.replace(const DashboardRoute());
          },
          child: BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppPalette.primary,
                                  AppPalette.primaryDark,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppPalette.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_add_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Join Flutter Prakash',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enterprise Clean Architecture & BLoC Engine',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Full Name Reactive Input
                        ReactiveTextField(
                          field: state.fullName,
                          onChanged: _registerCubit.onFullNameChanged,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(height: 16),

                        // Corporate Email Reactive Input
                        ReactiveTextField(
                          field: state.email,
                          onChanged: _registerCubit.onEmailChanged,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(height: 16),

                        // Password Reactive Input
                        ReactiveTextField(
                          field: state.password,
                          onChanged: _registerCubit.onPasswordChanged,
                          obscureText: state.isPasswordObscured,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: _registerCubit.togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Reactive Input
                        ReactiveTextField(
                          field: state.confirmPassword,
                          onChanged: _registerCubit.onConfirmPasswordChanged,
                          obscureText: state.isConfirmPasswordObscured,
                          prefixIcon: const Icon(Icons.lock_clock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isConfirmPasswordObscured
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed:
                                _registerCubit.toggleConfirmPasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Terms & Conditions Reactive Checkbox
                        ReactiveCheckbox(
                          field: state.acceptTerms,
                          title: 'I agree to the Terms of Service & Privacy',
                          onChanged: _registerCubit.onAcceptTermsChanged,
                        ),
                        const SizedBox(height: 24),

                        // Reactive Submission Button
                        ReactiveFormButton<RegisterCubit, RegisterState>(
                          label: 'Create Account',
                          icon: Icons.arrow_forward_rounded,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPalette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.router.maybePop(),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppPalette.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
