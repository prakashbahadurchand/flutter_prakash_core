import 'dart:async';
import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/forgot_password_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/verify_email_request_model.dart';
import 'package:flutter_prakash_core_example/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_prakash_core_example/features/auth/presentation/blocs/email_verification/email_verification_state.dart';

@injectable
class EmailVerificationCubit
    extends BaseFormCubit<EmailVerificationState, bool> {
  final AuthRepository _repository;
  Timer? _timer;

  EmailVerificationCubit(this._repository) : super(EmailVerificationState());

  void init(String email) {
    safeEmit(state.copyWith(email: email));
    _startCountdown();
  }

  void otpChanged(String value) {
    final field = state.otpCode(value);
    safeEmit(state.copyWith(
      otpCode: field,
      isValid: field.isValid && value.length == 6,
    ));
  }

  void _startCountdown() {
    _timer?.cancel();
    safeEmit(state.copyWith(resendCountdown: 60, canResend: false));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown <= 1) {
        timer.cancel();
        safeEmit(state.copyWith(resendCountdown: 0, canResend: true));
      } else {
        safeEmit(state.copyWith(resendCountdown: state.resendCountdown - 1));
      }
    });
  }

  Future<void> resendCode() async {
    if (!state.canResend) return;

    final result = await _repository.forgotPassword(
      ForgotPasswordRequestModel(email: state.email),
    );

    result.when(
      success: (msg) {
        emitEffect(ShowToastEffect(msg));
        _startCountdown();
      },
      error: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }

  Future<void> verifyCode() async {
    await submitForm(
      call: () => _repository.verifyEmail(
        VerifyEmailRequestModel(
          email: state.email,
          otpCode: state.otpCode.value,
        ),
      ),
      onSuccess: (_) {
        emitEffect(const ShowToastEffect('Email verified successfully!'));
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
