import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/entities/topic.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class PostTopicBloc {
  PostTopicBloc(
    this._authenticationRepository,
    this._topicRepository,
  )   : assert(_authenticationRepository != null),
        assert(_topicRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final TopicRepository _topicRepository;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<File> imageFileController =
      BehaviorSubject<File>.seeded(null);
  final BehaviorSubject<String> imageController =
      BehaviorSubject<String>.seeded('');

  Future<void> postTopic() async {
    loadingController.sink.add(true);
    try {
      final currentUser = await _authenticationRepository.getCurrentUser();

      if (imageFileController.value == null) {
        await _topicRepository.postTopic(
          userId: currentUser.id,
          topic: Topic(
            id: 'a',
            text: titleController.text,
            imageUrl: '',
            createdAt: DateTime.now(),
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
        await _topicRepository.postTopic(
          userId: currentUser.id,
          topic: Topic(
            id: 'a',
            text: titleController.text,
            imageUrl: imageName,
            createdAt: DateTime.now(),
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
