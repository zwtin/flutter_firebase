import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/use_cases/current_user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/push_notification_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NewRegisterBloc {
  NewRegisterBloc(
    this._authenticationRepository,
    this._userRepository,
    this._pushNotificationRepository,
  )   : assert(_authenticationRepository != null),
        assert(_userRepository != null),
        assert(_pushNotificationRepository != null) {
    setupEmail();
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final PushNotificationRepository _pushNotificationRepository;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final PublishSubject<CurrentUser> currentUserController =
      PublishSubject<CurrentUser>();
  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> setupEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('register_email');
      emailController.text = email;
      await prefs.remove('register_email');
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _userRepository.createUser(userId: currentUser.id);
      await registerDeviceToken();
      currentUserController.sink.add(currentUser);
    } on Exception catch (error) {
      loadingController.sink.add(false);
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
    } on Exception catch (error) {
      return;
    }
  }

  Future<void> dispose() async {
    await currentUserController.close();
    await loadingController.close();
  }
}
