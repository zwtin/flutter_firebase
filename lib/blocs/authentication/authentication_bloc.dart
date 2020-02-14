import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_event.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_repository.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required AuthenticationRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  final AuthenticationRepository _authRepository;

  @override
  AuthenticationState get initialState => AuthenticationInProgress();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final currentUser = await _authRepository.getCurrentUser();
        yield AuthenticationSuccess(currentUser);
      } else {
        yield AuthenticationFailure();
      }
    } on Exception catch (_) {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield AuthenticationSuccess(await _authRepository.getCurrentUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield AuthenticationFailure();
    _authRepository.signOut();
  }
}
