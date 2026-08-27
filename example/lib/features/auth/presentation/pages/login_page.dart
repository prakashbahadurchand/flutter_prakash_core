import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/login/login_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/login/login_state.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_divider.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_footer.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_social_buttons.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<LoginCubit>();
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
      body: SafeArea(
        child: BlocProvider.value(
          value: _cubit,
          child: ReactiveFormListener<LoginCubit, LoginState>(
            successMessage: 'Welcome back!',
            onSuccess: (context, state) {
              context.router.replaceAll([const DashboardRoute()]);
            },
            child: BlocBuilder<LoginCubit, LoginState>(
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
                          title: 'Welcome Back',
                          subtitle: 'Sign in to access your account & dashboard',
                          icon: Icons.lock_outline_rounded,
                        ),
                        const SizedBox(height: 32),

                        // Form container
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
                                onChanged: _cubit.onEmailChanged,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 8),

                              // Remember Me & Forgot Password
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: state.rememberMe.value,
                                          onChanged: _cubit.onRememberMeChanged,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.router.push(
                                        const ForgotPasswordRoute(),
                                      );
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                        'Sign In',
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
                        const AuthDivider(),
                        const SizedBox(height: 20),
                        const AuthSocialButtons(),
                        const SizedBox(height: 32),

                        AuthFooter(
                          prompt: "Don't have an account?",
                          actionLabel: 'Sign Up',
                          onAction: () {
                            context.router.push(const RegisterRoute());
                          },
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
