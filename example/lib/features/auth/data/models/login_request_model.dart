class LoginRequestModel {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequestModel({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}
