import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart';

class AuthSocialButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onGithubPressed;

  const AuthSocialButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onGithubPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          icon: Icons.g_mobiledata_rounded,
          label: 'Google',
          color: Colors.red,
          isDark: isDark,
          onTap: onGooglePressed ?? () => Toast.info('Google Sign-In clicked'),
        ),
        const SizedBox(width: 16),
        _buildSocialIcon(
          icon: Icons.apple_rounded,
          label: 'Apple',
          color: isDark ? Colors.white : Colors.black,
          isDark: isDark,
          onTap: onApplePressed ?? () => Toast.info('Apple Sign-In clicked'),
        ),
        const SizedBox(width: 16),
        _buildSocialIcon(
          icon: Icons.code_rounded,
          label: 'GitHub',
          color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
          isDark: isDark,
          onTap: onGithubPressed ?? () => Toast.info('GitHub Sign-In clicked'),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          ),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
