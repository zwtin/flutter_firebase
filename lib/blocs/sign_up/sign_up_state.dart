import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/models/current_user.dart';

@immutable
abstract class SignUpState extends Equatable {}

class SignUpInProgress extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpSuccess extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpFailure extends SignUpState {
  @override
  List<Object> get props => [];
}
