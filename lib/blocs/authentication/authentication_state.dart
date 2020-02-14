import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/models/current_user.dart';

@immutable
abstract class AuthenticationState extends Equatable {}

class AuthenticationInProgress extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  AuthenticationSuccess(this.currentUser);

  final CurrentUser currentUser;

  @override
  List<Object> get props => [currentUser];
}

class AuthenticationFailure extends AuthenticationState {
  @override
  List<Object> get props => [];
}
