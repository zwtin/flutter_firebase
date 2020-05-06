import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class PostEventBloc {
  PostEventBloc(
    this._authenticationRepository,
    this._itemRepository,
  )   : assert(_authenticationRepository != null),
        assert(_itemRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final ItemRepository _itemRepository;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<File> imageFileController =
      BehaviorSubject<File>.seeded(null);
  final BehaviorSubject<String> imageController =
      BehaviorSubject<String>.seeded('');

  Future<void> postItem() async {
    loadingController.sink.add(true);
    try {
      final currentUser = await _authenticationRepository.getCurrentUser();

      if (imageFileController.value == null) {
        await _itemRepository.postItem(
          userId: currentUser.id,
          item: Item(
            id: 'a',
            title: titleController.text,
            description: descriptionController.text,
            date: DateTime.now(),
            imageUrl: '',
            createdUser: currentUser.id,
          ),
        );
      } else {
        final imageName = randomString(16);
        final uploadTask = FirebaseStorage.instance
            .ref()
            .child(imageName)
            .putFile(imageFileController.value);
        await uploadTask.onComplete;
        await _itemRepository.postItem(
          userId: currentUser.id,
          item: Item(
            id: 'a',
            title: titleController.text,
            description: descriptionController.text,
            date: DateTime.now(),
            imageUrl: imageName,
            createdUser: currentUser.id,
          ),
        );
      }
      loadingController.sink.add(false);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> getImage() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFileController.sink.add(imageFile);
  }

  String randomString(int length) {
    const _randomChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const _charsLength = _randomChars.length;

    final rand = Random();
    final codeUnits = List.generate(
      length,
      (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return String.fromCharCodes(codeUnits);
  }

  Future<void> dispose() async {
    await loadingController.close();
    await imageController.close();
    await imageFileController.close();
  }
}
