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

  // output
  Stream<AuthenticationState> get screenState => _stateController.stream;

  Future<void> checkCurrentUser() async {
    _stateController.sink.add(AuthenticationInProgress());
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        _stateController.sink.add(AuthenticationFailure());
      } else {
        _stateController.sink.add(AuthenticationSuccess(currentUser));
      }
    } else {
      _stateController.sink.add(AuthenticationFailure());
    }
  }

  Future<void> loginWithMailAndPassword(String email, String password) async {
    _stateController.sink.add(AuthenticationInProgress());
    await _authRepository.signInWithEmailAndPassword(email, password);
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        _stateController.sink.add(AuthenticationFailure());
      } else {
        _stateController.sink.add(AuthenticationSuccess(currentUser));
      }
    } else {
      _stateController.sink.add(AuthenticationFailure());
    }
  }

  Future<void> signOut() async {
    _stateController.sink.add(AuthenticationInProgress());
    await _authRepository.signOut();
    final isSignedIn = await _authRepository.isSignedIn();
    if (isSignedIn) {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        _stateController.sink.add(AuthenticationFailure());
      } else {
        _stateController.sink.add(AuthenticationSuccess(currentUser));
      }
    } else {
      _stateController.sink.add(AuthenticationFailure());
    }
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
