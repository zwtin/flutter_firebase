import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';

class AuthenticationBloc implements Bloc {
  AuthenticationBloc() {
    _start();
  }

//  final AuthenticationRepository _authRepository;

  final _stateController = StreamController<AuthenticationState>();
  Stream<AuthenticationState> get onAdd => _stateController.stream;

  void _start() {
    _stateController.sink.add(AuthenticationInProgress());
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
