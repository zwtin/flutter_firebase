import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_repository.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_state.dart';
import 'package:flutter_firebase/models/user.dart';

class EditProfileBloc implements Bloc {
  EditProfileBloc(this._editProfileRepository)
      : assert(_editProfileRepository != null);

  final EditProfileRepository _editProfileRepository;

  final _stateController = StreamController<EditProfileState>();
  String name;
  String introduction;

  // output
  Stream<EditProfileState> get screenState => _stateController.stream;

  Future<void> updateProfile(User user) async {
    _stateController.sink.add(EditProfileInProgress());
    await _editProfileRepository.update(
        user.id,
        User(
            id: user.id,
            name: name,
            introduction: introduction,
            imageUrl: 'zwtin.jpg'));
    _stateController.sink.add(EditProfileSuccess());
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
