import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc implements Bloc {
  SignUpBloc(this._authenticationRepository)
      : assert(_authenticationRepository != null) {
//    reload();
  }

  final AuthenticationRepository _authenticationRepository;
  String inputEmail;
  String inputPassword;

  final _stateController = StreamController<SignUpState>();

  // output
  Stream<SignUpState> get screenState => _stateController.stream;
//
//  Future<void> reload() async {
//    _stateController.sink.add(SignUpSuccess());
//  }
//
//  Future<void> signUpWithEmailAndPassword() async {
//    if (inputEmail.isEmpty) {
//      return;
//    }
//    _stateController.sink.add(SignUpInProgress());
//    try {
//      await _signUpRepository.signUpWithEmailAndPassword(
//        inputEmail,
//        inputPassword,
//      );
//      final prefs = await SharedPreferences.getInstance();
//      await prefs.setString('email', inputEmail);
//    } on Exception catch (error) {
//      _stateController.sink.add(SignUpFailure());
//    }
//  }
//
//  Future<void> signUpWithGoogle() async {}
//
//  Future<void> signUpWithApple() async {}
//
//  Future<void> signUpWithTwitter() async {}
//
//  Future<void> signUpWithFacebook() async {}

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
