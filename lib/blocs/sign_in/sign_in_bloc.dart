import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_state.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc implements Bloc {
  SignInBloc(this._authenticationRepository)
      : assert(_authenticationRepository != null);

  final AuthenticationRepository _authenticationRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

//
//  Future<void> checkCurrentUser() async {
//    _stateController.sink.add(SignInInProgress());
//    try {
//      final isSignedIn = await _signInRepository.isSignedIn();
//      if (isSignedIn) {
//        final currentUser = await _signInRepository.getCurrentUser();
//        _stateController.sink.add(SignInSuccess(currentUser));
//      } else {
//        _stateController.sink.add(SignInSuccess(null));
//      }
//    } on Exception catch (error) {
//      _stateController.sink.add(SignInFailure());
//    }
//  }
//
  Future<void> loginWithEmailAndPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on Exception catch (error) {}
  }
//
//  Future<void> signOut() async {
//    _stateController.sink.add(SignInInProgress());
//    inputEmail = '';
//    inputPassword = '';
//    try {
//      await _signInRepository.signOut();
//      final isSignedIn = await _signInRepository.isSignedIn();
//      if (isSignedIn) {
//        final currentUser = await _signInRepository.getCurrentUser();
//        _stateController.sink.add(SignInSuccess(currentUser));
//      } else {
//        _stateController.sink.add(SignInSuccess(null));
//      }
//    } on Exception catch (error) {
//      _stateController.sink.add(SignInFailure());
//    }
//  }

  @override
  Future<void> dispose() async {}
}
