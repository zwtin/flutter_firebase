import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc implements Bloc {
  SignUpBloc(this._authenticationRepository)
      : assert(_authenticationRepository != null);

  final AuthenticationRepository _authenticationRepository;

  final TextEditingController emailController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> sendSignInWithEmailLink() async {
    if (emailController.text.isEmpty) {
      return;
    }
    loadingController.sink.add(true);
    try {
      await _authenticationRepository.sendSignInWithEmailLink(
        email: emailController.text,
      );
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  @override
  Future<void> dispose() async {
    await loadingController.close();
  }
}
