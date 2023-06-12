part of 'signup_cubit.dart';

enum SignupStatus {
  initial,
  submitting,
  success,
  failure,
  incorrectMatchPassword,
}

@immutable
class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.initial,
    this.email = '',
    this.password = '',
    this.password2 = '',
    this.user,
  });
  const SignupState.success(
    User loggeduser,
    this.email,
    this.password,
    this.password2,
  )   : status = SignupStatus.success,
        user = loggeduser;

  final String email;
  final String password;
  final String password2;
  final SignupStatus status;
  final User? user;

  bool get isSubmitting => status == SignupStatus.submitting;
  bool get isFilled =>
      email.trim().isNotEmpty &&
      password.trim().isNotEmpty &&
      password2.trim().isNotEmpty;
  bool get canDoSubmit => isFilled && status == SignupStatus.initial;
  bool get hasPasswordMatch => password == password2;
  bool get hasNotPasswordMatch => !hasPasswordMatch;

  SignupState updateEmail(String email) {
    return _copyWith(email: email, status: SignupStatus.initial);
  }

  SignupState updatePassword(String password) {
    return _copyWith(password: password, status: SignupStatus.initial);
  }

  SignupState updatePassword2(String password) {
    return _copyWith(password2: password, status: SignupStatus.initial);
  }

  SignupState updateStatus(SignupStatus status) {
    return _copyWith(status: status);
  }

  SignupState _copyWith({
    String? email,
    String? password,
    String? password2,
    SignupStatus? status,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      password2: password2 ?? this.password2,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [email, password, password2, status];
}
