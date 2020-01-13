import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignInEvent extends Equatable {
}

class SignInWithGoogleOnPressed extends SignInEvent {
    @override
    List<Object> get props => [];
}

class SignInAnonymouslyOnPressed extends SignInEvent {
    @override
    List<Object> get props => [];
}