import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/entities/alert.dart';
import 'package:flutter_firebase/entities/topic_entity.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

class PostTopicBloc {
  PostTopicBloc(
    this._authenticationRepository,
    this._topicRepository,
    this._storageRepository,
  )   : assert(_authenticationRepository != null),
        assert(_topicRepository != null),
        assert(_storageRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final TopicRepository _topicRepository;
  final StorageRepository _storageRepository;

  final TextEditingController textController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  final PublishSubject<Alert> alertController = PublishSubject<Alert>();

  final BehaviorSubject<File> imageFileController =
      BehaviorSubject<File>.seeded(null);

  Future<void> postTopic() async {
    loadingController.sink.add(true);
    try {
      final currentUser = await _authenticationRepository.getCurrentUser();

      if (imageFileController.value == null) {
        await _topicRepository.postTopic(
          userId: currentUser.id,
          topic: TopicEntity(
            id: '',
            text: textController.text,
            imageUrl: '',
            createdAt: DateTime.now(),
            createdUser: currentUser.id,
          ),
        );
      } else {
        final imageUrl =
            await _storageRepository.upload(imageFileController.value);
        await _topicRepository.postTopic(
          userId: currentUser.id,
          topic: TopicEntity(
            id: '',
            text: textController.text,
            imageUrl: imageUrl,
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

  Future<void> dispose() async {
    await loadingController.close();
    await imageFileController.close();
    await alertController.close();
  }
}
