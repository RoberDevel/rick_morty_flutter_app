import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:rick_morty_flutter_app/auth/auth.dart';
import 'package:rick_morty_flutter_app/firebase_options.dart';

class FirebaseAuthProvider implements AuthRepository {
  final firebase.FirebaseAuth _instance = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await _instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _store.collection('users').doc(_instance.currentUser!.uid).set({
        'favorites': [],
      });
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  User? get currentUser {
    final user = _instance.currentUser;
    if (user != null) {
      return user.isAnonymous ? User.empty : User.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<User> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await _instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    await _instance.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await _instance.sendPasswordResetEmail(email: toEmail);
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<User> logInWithoutAuth() async {
    try {
      await _instance.signInAnonymously();
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on firebase.FirebaseAuthException catch (e) {
      throw GenericAuthException();
    }
  }
}
