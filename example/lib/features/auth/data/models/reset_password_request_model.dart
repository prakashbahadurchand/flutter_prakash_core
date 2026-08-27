class ResetPasswordRequestModel {
  final String email;
  final String otpCode;
  final String newPassword;

  const ResetPasswordRequestModel({
    required this.email,
    required this.otpCode,
    required this.newPassword,
  });
}
