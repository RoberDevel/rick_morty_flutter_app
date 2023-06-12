import 'package:rick_morty_flutter_app/auth/auth.dart';

abstract class AuthRepository {
  Future<User> createUser({
    required String email,
    required String password,
  });

  User? get currentUser;

  Future<User> logIn({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required String toEmail});

  Future<User> logInWithoutAuth();
}
