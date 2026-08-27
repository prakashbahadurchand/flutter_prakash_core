import 'dart:async';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/forgot_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/email_verification/email_verification_state.dart';

@injectable
class EmailVerificationCubit extends FormCubit<EmailVerificationState> {
  final AuthRepository _authRepository;
  Timer? _timer;

  EmailVerificationCubit(this._authRepository)
    : super(EmailVerificationState.initial());

  void init(String email) {
    emit(state.copyWith(email: email));
    _startCountdown();
  }

  void onOtpChanged(String value) =>
      emit(state.copyWith(otpCode: state.otpCode(value)));

  void _startCountdown() {
    _timer?.cancel();
    emit(state.copyWith(resendCountdown: 60, canResend: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        emit(state.copyWith(resendCountdown: 0, canResend: true));
      } else {
        emit(state.copyWith(resendCountdown: state.resendCountdown - 1));
      }
    });
  }

  Future<void> resendCode() async {
    if (!state.canResend) return;
    _startCountdown();
    await _authRepository.forgotPassword(
      ForgotPasswordRequestModel(email: state.email),
    );
    emitEffect(
      const ShowToastEffect('A fresh verification code has been dispatched.'),
    );
  }

  @override
  Future<Result<dynamic>> performSubmit() {
    return _authRepository.verifyEmail(state.toDto());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
