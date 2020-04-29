import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/push_notification_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_firebase/entities/alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUpBloc {
  SignUpBloc(
    this._authenticationRepository,
    this._userRepository,
    this._pushNotificationRepository,
  )   : assert(_authenticationRepository != null),
        assert(_userRepository != null),
        assert(_pushNotificationRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final PushNotificationRepository _pushNotificationRepository;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final TextEditingController emailController = TextEditingController();

  final PublishSubject<Alert> alertController = PublishSubject<Alert>();
  final PublishSubject<void> sentRegisterEmailController =
      PublishSubject<void>();
  final PublishSubject<void> popController = PublishSubject<void>();
  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> sendSignInWithEmailLink() async {
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
    loadingController.sink.add(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('register_email', emailController.text);
      await _authenticationRepository.sendSignInWithEmailLink(
        email: emailController.text,
      );
      sentRegisterEmailController.sink.add(null);
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

  Future<void> signUpWithGoogle() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithGoogle();
      final currentUser = await _authenticationRepository.getCurrentUser();
      final isExistUser =
          await _userRepository.isExistUser(userId: currentUser.id);
      if (isExistUser) {
        await _authenticationRepository.signOut();
        loadingController.sink.add(false);
        const errorAlert = Alert(
          title: 'エラー',
          subtitle: 'このアカウントはすでに存在しています',
          style: null,
          showCancelButton: false,
          onPress: null,
        );
        alertController.sink.add(errorAlert);
        return;
      } else {
        await _userRepository.createUser(userId: currentUser.id);
        await registerDeviceToken();
        loadingController.sink.add(false);
      }
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

  Future<void> signUpWithApple() async {
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.signInWithApple();
      final currentUser = await _authenticationRepository.getCurrentUser();
      final isExistUser =
          await _userRepository.isExistUser(userId: currentUser.id);
      if (isExistUser) {
        await _authenticationRepository.signOut();
        loadingController.sink.add(false);
        const errorAlert = Alert(
          title: 'エラー',
          subtitle: 'このアカウントはすでに存在しています',
          style: null,
          showCancelButton: false,
          onPress: null,
        );
        alertController.sink.add(errorAlert);
        return;
      } else {
        await _userRepository.createUser(userId: currentUser.id);
        await registerDeviceToken();
        loadingController.sink.add(false);
      }
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

  Future<void> registerDeviceToken() async {
    try {
      _firebaseMessaging.requestNotificationPermissions();
      final token = await _firebaseMessaging.getToken();
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _pushNotificationRepository.registerDeviceToken(
        userId: currentUser.id,
        deviceToken: token,
      );
    } on Exception catch (error) {}
  }

  Future<void> dispose() async {
    await alertController.close();
    await sentRegisterEmailController.close();
    await popController.close();
    await loadingController.close();
  }
}
