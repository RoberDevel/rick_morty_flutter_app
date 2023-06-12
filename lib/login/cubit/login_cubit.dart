import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginState());

  final AuthRepository _authRepository;

  void emailChanged(String value) {
    emit(state.updateEmail(value));
  }

  void passwordChanged(String value) {
    emit(state.updatePassword(value));
  }

  Future<void> login() async {
    emit(state.updateStatus(LoginStatus.submitting));
    try {
      final user = await _authRepository.logIn(
        email: state.email,
        password: state.password,
      );
      emit(LoginState.success(user, state.email, state.password));
    } on UserNotFoundAuthException catch (e) {
      emit(state.updateStatus(LoginStatus.userNotFoundFailure));
    } on WrongPasswordAuthException catch (e) {
      emit(state.updateStatus(LoginStatus.wrongPasswordFailure));
    } catch (e) {
      emit(state.updateStatus(LoginStatus.genericFailure));
    }
  }

  Future<void> loginWithoutAuth() async {
    emit(state.updateStatus(LoginStatus.submitting));
    // try {
    final user = await _authRepository.logInWithoutAuth();

    emit(LoginState.success(user, '', ''));
    // } catch (e) {
    //   emit(
    //     state.updateStatus(LoginStatus.failure),
    //  );
    // }
  }
}
