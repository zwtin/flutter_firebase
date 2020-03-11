import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_repository.dart';

class AuthenticationBloc implements Bloc {
  AuthenticationBloc(this._authRepository) : assert(_authRepository != null) {
    checkCurrentUser();
  }

  final AuthenticationRepository _authRepository;

  final _stateController = StreamController<AuthenticationState>();
  String inputEmail;
  String inputPassword;

  // output
  Stream<AuthenticationState> get screenState => _stateController.stream;

  Future<void> checkCurrentUser() async {
    _stateController.sink.add(AuthenticationInProgress());
    try {
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _authRepository.getCurrentUser();
        _stateController.sink.add(AuthenticationSuccess(currentUser));
      } else {
        _stateController.sink.add(AuthenticationSuccess(null));
      }
    } on Exception catch (error) {
      _stateController.sink.add(AuthenticationFailure());
    }
  }

  Future<void> loginWithEmailAndPassword() async {
    if (inputEmail.isEmpty || inputPassword.isEmpty) {
      return;
    }
    _stateController.sink.add(AuthenticationInProgress());
    try {
      await _authRepository.signInWithEmailAndPassword(
        inputEmail,
        inputPassword,
      );
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _authRepository.getCurrentUser();
        _stateController.sink.add(AuthenticationSuccess(currentUser));
      } else {
        _stateController.sink.add(AuthenticationSuccess(null));
      }
    } on Exception catch (error) {
      _stateController.sink.add(AuthenticationFailure());
    }
  }

  Future<void> signOut() async {
    _stateController.sink.add(AuthenticationInProgress());
    inputEmail = '';
    inputPassword = '';
    try {
      await _authRepository.signOut();
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _authRepository.getCurrentUser();
        _stateController.sink.add(AuthenticationSuccess(currentUser));
      } else {
        _stateController.sink.add(AuthenticationSuccess(null));
      }
    } on Exception catch (error) {
      _stateController.sink.add(AuthenticationFailure());
    }
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
