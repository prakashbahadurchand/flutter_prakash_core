import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/config/config.dart';
import 'package:flutter_prakash_core_example/core/core.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/change_password/change_password_cubit.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/change_password/change_password_state.dart';

@RoutePage()
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChangePasswordCubit>(),
      child: const _ChangePasswordForm(),
    );
  }
}

class _ChangePasswordForm extends StatelessWidget {
  const _ChangePasswordForm();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final cubit = context.read<ChangePasswordCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password'), centerTitle: true),
      body: SafeArea(
        child: ReactiveFormListener<ChangePasswordCubit, ChangePasswordState>(
          successMessage: 'Password successfully updated!',
          onSuccess: (context, state) {
            context.router.maybePop();
          },
          child: SingleChildScrollView(
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
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                      // Current Password (Rebuilds ONLY on currentPassword/obscure changes)
                      BlocSelector<ChangePasswordCubit, ChangePasswordState,
                          (Field<String>, bool)>(
                        selector: (state) => (
                          state.currentPassword,
                          state.isCurrentPasswordObscured
                        ),
                        builder: (context, data) {
                          final (currentPassword, isObscured) = data;
                          return ReactiveTextField(
                            field: currentPassword,
                            onChanged: cubit.onCurrentPasswordChanged,
                            obscureText: isObscured,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed:
                                  cubit.toggleCurrentPasswordVisibility,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // New Password (Rebuilds ONLY on newPassword/obscure changes)
                      BlocSelector<ChangePasswordCubit, ChangePasswordState,
                          (Field<String>, bool)>(
                        selector: (state) => (
                          state.newPassword,
                          state.isNewPasswordObscured
                        ),
                        builder: (context, data) {
                          final (newPassword, isObscured) = data;
                          return ReactiveTextField(
                            field: newPassword,
                            onChanged: cubit.onNewPasswordChanged,
                            obscureText: isObscured,
                            prefixIcon:
                                const Icon(Icons.lock_reset_outlined),
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

                      // Confirm Password (Rebuilds ONLY on confirmPassword/obscure changes)
                      BlocSelector<ChangePasswordCubit, ChangePasswordState,
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
                                const Icon(Icons.check_circle_outline),
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
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button (Rebuilds ONLY on loading status changes)
                BlocSelector<ChangePasswordCubit, ChangePasswordState, bool>(
                  selector: (state) => state.status.isLoading,
                  builder: (context, isLoading) {
                    return ElevatedButton(
                      onPressed: isLoading ? null : cubit.submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
