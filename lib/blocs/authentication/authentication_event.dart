import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
}

class AppStarted extends AuthenticationEvent {
    @override
    List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
    @override
    List<Object> get props => [];
}

class LoggedOut extends AuthenticationEvent {
    @override
    List<Object> get props => [];
}
