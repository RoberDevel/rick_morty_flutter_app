part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  // const AuthState._(this.status, {this.user, this.isPartaker = false});
  const AuthState._({
    this.user,
    this.status = AuthStatus.unknown,
  });

  const AuthState.initial() : this._();

  const AuthState.authenticated(User user)
      : this._(
          user: user,
          status: AuthStatus.authenticated,
        );

  const AuthState.unauthenticated()
      : this._(
          status: AuthStatus.unauthenticated,
        );

  final User? user;
  final AuthStatus status;

  @override
  List<Object?> get props => [user, status];
}
