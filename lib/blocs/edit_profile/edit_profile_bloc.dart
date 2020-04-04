import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_state.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileBloc implements Bloc {
  EditProfileBloc(
    this._userRepository,
    this._authenticationRepository,
  )   : assert(_userRepository != null),
        assert(_authenticationRepository != null) {
    start();
  }

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController introductionController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<File> imageFileController =
      BehaviorSubject<File>.seeded(null);
  final BehaviorSubject<String> imageController =
      BehaviorSubject<String>.seeded('');

  Future<void> start() async {
    try {
      final currentUser = await _authenticationRepository.getCurrentUser();
      final user = await _userRepository.getUser(userId: currentUser.id);
      nameController.text = user.name;
      introductionController.text = user.introduction;
      final imageUrl = await FirebaseStorage.instance
          .ref()
          .child(user.imageUrl)
          .getDownloadURL() as String;
      imageController.sink.add(imageUrl);
    } on Exception catch (error) {}
  }

  Future<void> updateProfile() async {
    loadingController.sink.add(true);
    final currentUser = await _authenticationRepository.getCurrentUser();
    final user = await _userRepository.getUser(userId: currentUser.id);

    if (imageFileController.value == null) {
      await _userRepository.updateUser(
        userId: currentUser.id,
        newUser: User(
          id: user.id,
          name: nameController.text,
          introduction: introductionController.text,
          imageUrl: user.imageUrl,
        ),
      );
    } else {
      final imageName = randomString(16);
      final uploadTask = FirebaseStorage.instance
          .ref()
          .child(imageName)
          .putFile(imageFileController.value);
      await uploadTask.onComplete;
      await _userRepository.updateUser(
        userId: currentUser.id,
        newUser: User(
          id: user.id,
          name: nameController.text,
          introduction: introductionController.text,
          imageUrl: imageName,
        ),
      );
    }
    loadingController.sink.add(false);
  }

  Future<void> getImage() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFileController.sink.add(imageFile);
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
    await loadingController.close();
    await imageController.close();
    await imageFileController.close();
  }
}
