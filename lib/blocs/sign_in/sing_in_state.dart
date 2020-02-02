import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignInState extends Equatable {}

class SignInEmpty extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInLoading extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInSuccess extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInFailure extends SignInState {
  @override
  List<Object> get props => [];
}
