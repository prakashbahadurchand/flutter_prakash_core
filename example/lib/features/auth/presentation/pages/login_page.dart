import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/login/login_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/login/login_state.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_divider.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_footer.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_form_card.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/widgets/auth_social_buttons.dart';
import 'package:flutter_prakash_core_example/features/common/presentation/widgets/common_submit_button.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Scaffold(
      body: SafeArea(
        child: ReactiveFormListener<LoginCubit, LoginState>(
          successMessage: 'Welcome back!',
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
                  const AuthHeader(
                    title: 'Welcome Back',
                    subtitle: 'Sign in to access your account & dashboard',
                    icon: Icons.lock_outline_rounded,
                  ),
                  const SizedBox(height: 32),

                  // Form Container
                  CommonFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field (Rebuilds ONLY on email state changes)
                        BlocSelector<LoginCubit, LoginState, Field<String>>(
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
                        const SizedBox(height: 16),

                        // Password Field & Visibility (Rebuilds ONLY on password or obscure state changes)
                        BlocSelector<
                          LoginCubit,
                          LoginState,
                          (Field<String>, bool)
                        >(
                          selector: (state) =>
                              (state.password, state.isPasswordObscured),
                          builder: (context, passwordData) {
                            final (password, isObscured) = passwordData;
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
                        const SizedBox(height: 8),

                        // Remember Me & Forgot Password Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child:
                                      BlocSelector<
                                        LoginCubit,
                                        LoginState,
                                        bool
                                      >(
                                        selector: (state) =>
                                            state.rememberMe.value,
                                        builder: (context, rememberMeValue) {
                                          return Checkbox(
                                            value: rememberMeValue,
                                            onChanged:
                                                cubit.onRememberMeChanged,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          );
                                        },
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

                        // Submit Button (Rebuilds ONLY on loading status changes)
                        BlocSelector<LoginCubit, LoginState, bool>(
                          selector: (state) => state.status.isLoading,
                          builder: (context, isLoading) {
                            return CommonSubmitButton(
                              isLoading: isLoading,
                              onPressed: cubit.submit,
                              label: 'Sign In',
                            );
                          },
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
          ),
        ),
      ),
    );
  }
}
