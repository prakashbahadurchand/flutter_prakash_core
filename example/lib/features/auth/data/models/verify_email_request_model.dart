class VerifyEmailRequestModel {
  final String email;
  final String otpCode;

  const VerifyEmailRequestModel({
    required this.email,
    required this.otpCode,
  });
}
