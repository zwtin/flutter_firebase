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
    if (nameController.text.isEmpty) {
      // ユーザー名入力チェック
      const alert = Alert(
        title: 'エラー',
        subtitle: 'ユーザー名が未入力です',
        style: SweetAlertStyle.error,
        showCancelButton: false,
        onPress: null,
      );
      alertController.sink.add(alert);
      return;
    }
    if (introductionController.text.isEmpty) {
      // 自己紹介入力チェック
      const alert = Alert(
        title: 'エラー',
        subtitle: '自己紹介が未入力です',
        style: SweetAlertStyle.error,
        showCancelButton: false,
        onPress: null,
      );
      alertController.sink.add(alert);
      return;
    }

    // インジケーターを表示
    loadingController.sink.add(true);

    try {
      final currentUser = await _authenticationRepository.getCurrentUser();
      final user = await _userRepository.getUser(userId: currentUser.id);

      // 画像がある場合は投稿して投稿先URLを保存
      var imageUrl = '';
      if (imageFileController.value != null) {
        imageUrl = await _storageRepository.upload(imageFileController.value);
      }

      // ユーザー情報の更新があれば投稿
      await _userRepository.updateUser(
        userId: currentUser.id,
        newUser: User()
          ..name = user.name == nameController.text ? null : nameController.text
          ..introduction = user.introduction == introductionController.text
              ? null
              : introductionController.text
          ..imageUrl = imageFileController.value == null ? null : imageUrl,
      );

      // インジケーターを非表示
      loadingController.sink.add(false);

      // 投稿完了アラートを表示
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
    } on Exception catch (error) {
      // 投稿エラーアラートを表示
      const alert = Alert(
        title: 'エラー',
        subtitle: '通信エラーが発生しました',
        style: SweetAlertStyle.error,
        showCancelButton: false,
        onPress: null,
      );
      alertController.sink.add(alert);
      return;
    }
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
