import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/use_cases/user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_firebase/use_cases/alert.dart';
import 'package:sweetalert/sweetalert.dart';

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

  // 画像URL（すでに設定されている画像を表示する用）
  final BehaviorSubject<String> imageController =
      BehaviorSubject<String>.seeded('');
  // 画像ファイル（フォトギャラリーから選択された画像を表示する用）
  final BehaviorSubject<File> imageFileController =
      BehaviorSubject<File>.seeded(null);

  // アラート表示用
  final PublishSubject<Alert> alertController = PublishSubject<Alert>();
  // 前画面へ戻る
  final PublishSubject<void> popController = PublishSubject<void>();

  Future<void> start() async {
    try {
      final currentUser = await _authenticationRepository.getCurrentUser();
      final user = await _userRepository.getUser(userId: currentUser.id);
      nameController.text = user.name;
      introductionController.text = user.introduction;
      imageController.sink.add(user.imageUrl);
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
    var alert = Alert(
      title: '投稿完了',
      subtitle: 'プロフィールを更新しました',
      style: SweetAlertStyle.success,
      showCancelButton: false,
      onPress: (bool isConfirm) {
        popController.sink.add(null);
        return true;
      },
    );
    alertController.sink.add(alert);
  }

  Future<void> getImage() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    imageFileController.sink.add(imageFile);
    imageController.sink.add(null);
  }

  Future<void> dispose() async {
    await loadingController.close();
    await imageController.close();
    await imageFileController.close();
    await alertController.close();
    await popController.close();
  }
}
