import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpBloc {
  SignUpBloc(this._authenticationRepository, this._userRepository)
      : assert(_authenticationRepository != null),
        assert(_userRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  final TextEditingController emailController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> sendSignInWithEmailLink() async {
    if (emailController.text.isEmpty) {
      return;
    }
    loadingController.sink.add(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('register_email', emailController.text);
      await _authenticationRepository.sendSignInWithEmailLink(
        email: emailController.text,
      );
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> signUpWithGoogle() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithGoogle();
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _userRepository.createUser(userId: currentUser.id);
      loadingController.sink.add(false);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> signUpWithApple() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithApple();
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _userRepository.createUser(userId: currentUser.id);
      loadingController.sink.add(false);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> dispose() async {
    await loadingController.close();
  }
}
