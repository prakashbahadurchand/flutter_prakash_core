class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
  });
}
