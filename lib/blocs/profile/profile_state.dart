import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/entities/user.dart';

@immutable
abstract class ProfileState extends Equatable {}

class ProfileInProgress extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileSuccess extends ProfileState {
  ProfileSuccess({@required this.user}) : assert(user != null);

  final Stream<User> user;

  @override
  List<Object> get props => [user];
}

class ProfileFailure extends ProfileState {
  ProfileFailure({@required this.exception}) : assert(exception != null);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}
