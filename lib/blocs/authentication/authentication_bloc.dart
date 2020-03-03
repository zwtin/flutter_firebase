import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_repository.dart';

class AuthenticationBloc implements Bloc {
  AuthenticationBloc(this._authRepository) : assert(_authRepository != null) {
    _readController.stream.listen((_) => _start());
  }

  final AuthenticationRepository _authRepository;

  final _stateController = StreamController<AuthenticationState>();
  final _readController = StreamController<void>();

  // input
  StreamSink<void> get read => _readController.sink;
  // output
  Stream<AuthenticationState> get onAdd => _stateController.stream;

  void _start() {
    _stateController.sink.add(AuthenticationInProgress());
    Timer(const Duration(seconds: 3), _onTimer);
  }

  void _onTimer() {
    _stateController.sink.add(AuthenticationFailure());
  }

  Future<bool> isSignIn() async {
    final aaa = await _authRepository.isSignedIn();
    return aaa;
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _readController.close();
  }
}
