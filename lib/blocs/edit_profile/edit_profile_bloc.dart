import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_repository.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_state.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileBloc implements Bloc {
  EditProfileBloc(this._editProfileRepository)
      : assert(_editProfileRepository != null);

  final EditProfileRepository _editProfileRepository;

  final _stateController = StreamController<EditProfileState>();
  final _imageController = StreamController<Image>();

  String name;
  String introduction;
  File imageFile;

  // output
  Stream<EditProfileState> get screenState => _stateController.stream;
  Stream<Image> get selectedImage => _imageController.stream;

  Future<void> updateProfile(User user) async {
    _stateController.sink.add(EditProfileInProgress());

    final imageName = randomString(16);

    final StorageUploadTask uploadTask =
        FirebaseStorage.instance.ref().child(imageName).putFile(imageFile);

    await uploadTask.onComplete;

    await _editProfileRepository.update(
        user.id,
        User(
            id: user.id,
            name: name,
            introduction: introduction,
            imageUrl: imageName));
    _stateController.sink.add(EditProfileSuccess());
  }

  Future<void> getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    _imageController.sink.add(Image.file(imageFile));
  }

  String randomString(int length) {
    const _randomChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const _charsLength = _randomChars.length;

    final rand = new Random();
    final codeUnits = new List.generate(
      length,
      (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return new String.fromCharCodes(codeUnits);
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _imageController.close();
  }
}
