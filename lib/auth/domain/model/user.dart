import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';

@immutable
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory User.fromFirebase(firebase.User user) => User(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );

  static const empty = User(id: '', email: '', isEmailVerified: false);
  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => !isEmpty;

  final String id;
  final String email;
  final bool isEmailVerified;

  @override
  List<Object?> get props => [id, email, isEmailVerified];
}
