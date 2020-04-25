import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc {
  SignInBloc(this._authenticationRepository)
      : assert(_authenticationRepository != null);

  final AuthenticationRepository _authenticationRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final PublishSubject<CurrentUser> currentUserController =
      PublishSubject<CurrentUser>();
  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> loginWithEmailAndPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final currentUser = await _authenticationRepository.getCurrentUser();
      currentUserController.sink.add(currentUser);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> loginWithGoogle() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithGoogle();
      final currentUser = await _authenticationRepository.getCurrentUser();
      currentUserController.sink.add(currentUser);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> loginWithApple() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithApple();
      final currentUser = await _authenticationRepository.getCurrentUser();
      currentUserController.sink.add(currentUser);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> dispose() async {
    await currentUserController.close();
    await loadingController.close();
  }
}
