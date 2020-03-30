import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/profile/profile_state.dart';
import 'package:flutter_firebase/repositories/profile_repository.dart';

class ProfileBloc implements Bloc {
  ProfileBloc(this._id, this._profileRepository)
      : assert(_id != null),
        assert(_profileRepository != null) {
    getUser();
  }

  final String _id;
  final ProfileRepository _profileRepository;

  final _stateController = StreamController<ProfileState>();

  // output
  Stream<ProfileState> get screenState => _stateController.stream;

  void getUser() {
    try {
      final user = _profileRepository.fetch(_id);
      _stateController.sink.add(ProfileSuccess(user: user));
    } on Exception catch (error) {
      _stateController.sink.add(ProfileFailure(exception: error));
    }
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
