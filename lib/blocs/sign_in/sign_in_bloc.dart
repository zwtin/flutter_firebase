import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_firebase/entities/alert.dart';

class SignInBloc {
  SignInBloc(
    this._authenticationRepository,
    this._userRepository,
  )   : assert(_authenticationRepository != null),
        assert(_userRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final PublishSubject<void> popController = PublishSubject<void>();
  final PublishSubject<Alert> alertController = PublishSubject<Alert>();
  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> loginWithEmailAndPassword() async {
    if (emailController.text.isEmpty) {
      const errorAlert = Alert(
        title: 'エラー',
        subtitle: 'メールアドレスを入力してください',
        style: null,
        showCancelButton: false,
        onPress: null,
      );
      alertController.sink.add(errorAlert);
      return;
    }
    if (passwordController.text.isEmpty) {
      const errorAlert = Alert(
        title: 'エラー',
        subtitle: 'パスワードを入力してください',
        style: null,
        showCancelButton: false,
        onPress: null,
      );
      alertController.sink.add(errorAlert);
      return;
    }
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final currentUser = await _authenticationRepository.getCurrentUser();
      popController.sink.add(null);
    } on Exception catch (error) {
      loadingController.sink.add(false);
      final errorAlert = Alert(
        title: 'エラー',
        subtitle: error.toString(),
        style: null,
        showCancelButton: false,
        onPress: null,
      );
      alertController.sink.add(errorAlert);
    }
  }

  Future<void> loginWithGoogle() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithGoogle();
      final currentUser = await _authenticationRepository.getCurrentUser();
      final isExistUser =
          await _userRepository.isExistUser(userId: currentUser.id);
      if (isExistUser) {
        loadingController.sink.add(false);
        return;
      } else {
        await _authenticationRepository.signOut();
        loadingController.sink.add(false);
        const errorAlert = Alert(
          title: 'エラー',
          subtitle: 'このアカウントは存在しません',
          style: null,
          showCancelButton: false,
          onPress: null,
        );
        alertController.sink.add(errorAlert);
        return;
      }
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> loginWithApple() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithApple();
      final currentUser = await _authenticationRepository.getCurrentUser();
      final isExistUser =
          await _userRepository.isExistUser(userId: currentUser.id);
      if (isExistUser) {
        loadingController.sink.add(false);
        return;
      } else {
        await _authenticationRepository.signOut();
        loadingController.sink.add(false);
        const errorAlert = Alert(
          title: 'エラー',
          subtitle: 'このアカウントは存在しません',
          style: null,
          showCancelButton: false,
          onPress: null,
        );
        alertController.sink.add(errorAlert);
        return;
      }
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> dispose() async {
    await popController.close();
    await alertController.close();
    await loadingController.close();
  }
}
