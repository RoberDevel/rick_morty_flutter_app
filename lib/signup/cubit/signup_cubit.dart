import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const SignupState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    emit(state.updateEmail(value));
  }

  void passwordChanged(String value) {
    emit(state.updatePassword(value));
  }

  void passwordChanged2(String value) {
    emit(state.updatePassword2(value));
  }

  Future<void> submit() async {
    emit(state.updateStatus(SignupStatus.submitting));
    if (state.hasNotPasswordMatch) {
      emit(state.updateStatus(SignupStatus.incorrectMatchPassword));
      return;
    }
    try {
      final user = await _authRepository.createUser(
        email: state.email,
        password: state.password,
      );
      emit(
        SignupState.success(user, state.email, state.password, state.password2),
      );
    } catch (e) {
      emit(state.updateStatus(SignupStatus.failure));
    }
  }
}
