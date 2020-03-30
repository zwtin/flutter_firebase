import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/entities/current_user.dart';

@immutable
abstract class SignInState extends Equatable {}

class SignInInProgress extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInSuccess extends SignInState {
  SignInSuccess(this.currentUser);

  final CurrentUser currentUser;

  @override
  List<Object> get props => [currentUser];
}

class SignInFailure extends SignInState {
  @override
  List<Object> get props => [];
}
