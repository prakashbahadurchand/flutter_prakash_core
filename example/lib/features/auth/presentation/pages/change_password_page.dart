import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/change_password/change_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/change_password/change_password_state.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final ChangePasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ChangePasswordCubit>();
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
      appBar: AppBar(title: const Text('Change Password'), centerTitle: true),
      body: SafeArea(
        child: BlocProvider.value(
          value: _cubit,
          child: ReactiveFormListener<ChangePasswordCubit, ChangePasswordState>(
            successMessage: 'Password successfully updated!',
            onSuccess: (context, state) {
              context.router.maybePop();
            },
            child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Security Settings',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your new password must be at least 6 characters and different from your current password.',
                        style: TextStyle(
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppPalette.surface(isDark),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          children: [
                            ReactiveTextField(
                              field: state.currentPassword,
                              onChanged: _cubit.onCurrentPasswordChanged,
                              obscureText: state.isCurrentPasswordObscured,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.isCurrentPasswordObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed:
                                    _cubit.toggleCurrentPasswordVisibility,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ReactiveTextField(
                              field: state.newPassword,
                              onChanged: _cubit.onNewPasswordChanged,
                              obscureText: state.isNewPasswordObscured,
                              prefixIcon:
                                  const Icon(Icons.lock_reset_outlined),
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
                                  const Icon(Icons.check_circle_outline),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: state.status.isLoading
                            ? null
                            : () => _cubit.submit(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: state.status.isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Update Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
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
