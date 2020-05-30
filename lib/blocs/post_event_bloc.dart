import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/entities/answer_entity.dart';
import 'package:flutter_firebase/entities/topic.dart';
import 'package:flutter_firebase/repositories/answer_repository.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class PostEventBloc {
  PostEventBloc(
    this.topic,
    this._authenticationRepository,
    this._answerRepository,
  )   : assert(topic != null),
        assert(_authenticationRepository != null),
        assert(_answerRepository != null);

  final AuthenticationRepository _authenticationRepository;
  final AnswerRepository _answerRepository;
  final Topic topic;

  final TextEditingController answerController = TextEditingController();

  final BehaviorSubject<bool> loadingController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> postAnswer() async {
    loadingController.sink.add(true);
    try {
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _answerRepository.postAnswer(
        userId: currentUser.id,
        answerEntity: AnswerEntity(
          id: 'a',
          text: answerController.text,
          createdAt: DateTime.now(),
          rank: 0,
          topicId: topic.id,
          createdUser: currentUser.id,
        ),
      );
      loadingController.sink.add(false);
    } on Exception catch (error) {
      loadingController.sink.add(false);
    }
  }

  Future<void> dispose() async {
    await loadingController.close();
  }
}
