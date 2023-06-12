import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthState.initial());

  final AuthRepository _authRepository;

  void checkStatus() {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void doLogin(User user) {
    emit(AuthState.authenticated(user));
  }

  Future<void> doLogout() async {
    await _authRepository.logOut();
    emit(const AuthState.unauthenticated());
  }
}
