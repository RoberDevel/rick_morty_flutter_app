part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  submitting,
  success,
  genericFailure,
  wrongPasswordFailure,
  userNotFoundFailure,
}

@immutable
class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
    this.user,
  });
  const LoginState.success(
    User loggedUser,
    this.email,
    this.password,
  )   : status = LoginStatus.success,
        user = loggedUser;

  final String email;
  final String password;
  final LoginStatus status;
  final User? user;

  bool get isFilled => email.trim().isNotEmpty && password.trim().isNotEmpty;
  bool get isSubmitting => status == LoginStatus.submitting;

  bool get canDoLogin => isFilled && LoginStatus.initial == status;

  LoginState updateEmail(String email) {
    return _copyWith(
      email: email,
      status: LoginStatus.initial,
    );
  }

  LoginState updatePassword(String password) {
    return _copyWith(
      password: password,
      status: LoginStatus.initial,
    );
  }

  LoginState updateStatus(LoginStatus status) {
    return _copyWith(status: status);
  }

  LoginState _copyWith({
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}
