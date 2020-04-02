import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_state.dart';
import 'package:flutter_firebase/repositories/sign_in_repository.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc implements Bloc {
  SignInBloc(this._signInRepository) : assert(_signInRepository != null) {
    checkCurrentUser();
  }

  final SignInRepository _signInRepository;

  final _stateController = StreamController<SignInState>();
  String inputEmail;
  String inputPassword;

  // output
  Stream<SignInState> get screenState => _stateController.stream;

  Future<void> checkCurrentUser() async {
    _stateController.sink.add(SignInInProgress());
    try {
      final isSignedIn = await _signInRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _signInRepository.getCurrentUser();
        _stateController.sink.add(SignInSuccess(currentUser));
      } else {
        _stateController.sink.add(SignInSuccess(null));
      }
    } on Exception catch (error) {
      _stateController.sink.add(SignInFailure());
    }
  }

  Future<void> loginWithEmailAndPassword() async {
    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      return;
    }
    _stateController.sink.add(SignInInProgress());
    try {
      await _signInRepository.signInWithEmailAndPassword(
        inputEmail,
        inputPassword,
      );
      final isSignedIn = await _signInRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _signInRepository.getCurrentUser();
        _stateController.sink.add(SignInSuccess(currentUser));
      } else {
        _stateController.sink.add(SignInSuccess(null));
      }
    } on Exception catch (error) {
      _stateController.sink.add(SignInFailure());
    }
  }

  Future<void> signOut() async {
    _stateController.sink.add(SignInInProgress());
    inputEmail = '';
    inputPassword = '';
    try {
      await _signInRepository.signOut();
      final isSignedIn = await _signInRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _signInRepository.getCurrentUser();
        _stateController.sink.add(SignInSuccess(currentUser));
      } else {
        _stateController.sink.add(SignInSuccess(null));
      }
    } on Exception catch (error) {
      _stateController.sink.add(SignInFailure());
    }
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
