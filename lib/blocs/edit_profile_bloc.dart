import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileBloc {
  EditProfileBloc(
    this._userRepository,
    this._authenticationRepository,
    this._storageRepository,
  )   : assert(_userRepository != null),
        assert(_authenticationRepository != null),
        assert(_storageRepository != null) {
    start();
  }

  final UserRepository _userRepository;
  final AuthenticationRepository _authenticationRepository;
  final StorageRepository _storageRepository;

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
    } on Exception catch (error) {
      return;
    }
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
      final imageUrl =
          await _storageRepository.upload(imageFileController.value);
      await _userRepository.updateUser(
        userId: currentUser.id,
        newUser: User(
          id: user.id,
          name: nameController.text,
          introduction: introductionController.text,
          imageUrl: imageUrl,
        ),
      );
    }
    loadingController.sink.add(false);
  }

  Future<void> getImage() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFileController.sink.add(imageFile);
  }

  Future<void> dispose() async {
    await loadingController.close();
    await imageController.close();
    await imageFileController.close();
  }
}
