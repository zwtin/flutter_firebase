import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/current_user.dart';

abstract class AuthenticationRepository {
  Stream<CurrentUser> getCurrentUserStream();

  Future<CurrentUser> getCurrentUser();

  Future<bool> isSignedIn();

  Future<void> signOut();

  Future<void> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> sendSignInWithEmailLink({
    @required String email,
  });

  Future<void> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<void> signInWithGoogle();

  Future<void> signInWithApple();
}
