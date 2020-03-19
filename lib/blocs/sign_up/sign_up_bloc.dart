import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_repository.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_state.dart';

class SignUpBloc implements Bloc {
  SignUpBloc(this._signUpRepository) : assert(_signUpRepository != null) {
    _readController.stream.listen((_) => _start());
  }

  final SignUpRepository _signUpRepository;
  String inputEmail;
  String inputPassword;

  final _stateController = StreamController<SignUpState>();
  final _readController = StreamController<void>();

  // input
  StreamSink<void> get read => _readController.sink;
  // output
  Stream<SignUpState> get onAdd => _stateController.stream;

  void _start() {
    _stateController.sink.add(SignUpInProgress());
    Timer(const Duration(seconds: 3), _onTimer);
  }

  void _onTimer() {
    _stateController.sink.add(SignUpFailure());
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _readController.close();
  }
}
