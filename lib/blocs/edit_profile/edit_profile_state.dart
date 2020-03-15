import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditProfileState extends Equatable {}

class EditProfileInProgress extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileSuccess extends EditProfileState {
  @override
  List<Object> get props => [];
}

class EditProfileFailure extends EditProfileState {
  EditProfileFailure({@required this.exception}) : assert(exception != null);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}
