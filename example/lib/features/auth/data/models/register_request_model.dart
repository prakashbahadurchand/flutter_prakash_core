class RegisterRequestModel {
  final String fullName;
  final String email;
  final String password;
  final bool agreeToTerms;

  const RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
    this.agreeToTerms = true,
  });
}
