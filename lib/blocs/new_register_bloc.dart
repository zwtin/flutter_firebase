import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_firebase/use_cases/alert.dart';

class NewRegisterBloc {
  NewRegisterBloc(
    this._authenticationRepository,
    this._userRepository,
  )   : assert(_authenticationRepository != null),
        assert(_userRepository != null) {
    setupEmail();
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final PublishSubject<void> popController = PublishSubject<void>();

  final PublishSubject<Alert> alertController = PublishSubject<Alert>();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> setupEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('register_email');
      emailController.text = email;
    } on Exception catch (error) {
      return;
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
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
      // メールアドレスとパスワードで会員登録
      await _authenticationRepository.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // 会員登録されたデータを元にDBにユーザー登録
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _userRepository.createUser(userId: currentUser.id);

      // 端末に保存されているメールアドレスを削除
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('register_email');

      // 画面を閉じる
      popController.sink.add(null);
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
