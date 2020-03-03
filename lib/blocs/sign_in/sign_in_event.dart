import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignInEvent extends Equatable {}

class SignInWithEmailAndPasswordOnPressed extends SignInEvent {
  SignInWithEmailAndPasswordOnPressed({
    @required this.email,
    @required this.password,
  })  : assert(email != null),
        assert(password != null);

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleOnPressed extends SignInEvent {
  @override
  List<Object> get props => [];
}

class SignInAnonymouslyOnPressed extends SignInEvent {
  @override
  List<Object> get props => [];
}
