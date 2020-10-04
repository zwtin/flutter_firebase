import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/use_cases/answer.dart';
import 'package:flutter_firebase/use_cases/create_answer_entity.dart';
import 'package:flutter_firebase/use_cases/current_user.dart';
import 'package:flutter_firebase/use_cases/favorite_answer_entity.dart';
import 'package:flutter_firebase/use_cases/user.dart';
import 'package:flutter_firebase/repositories/answer_repository.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/push_notification_repository.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  ProfileBloc(
    this._userId,
    this._userRepository,
    this._answerRepository,
    this._topicRepository,
  )   : assert(_userId != null),
        assert(_userRepository != null),
        assert(_answerRepository != null),
        assert(_topicRepository != null) {
    start();
  }

  final String _userId;
  final UserRepository _userRepository;
  final AnswerRepository _answerRepository;
  final TopicRepository _topicRepository;

  StreamSubscription<List<CreateAnswerEntity>> createAnswerListSubscription;
  List<CreateAnswerEntity> createAnswerEntityList = [];
  StreamSubscription<List<FavoriteAnswerEntity>> favoriteAnswerListSubscription;
  List<FavoriteAnswerEntity> favoriteAnswerEntityList = [];

  final ScrollController createAnswerScrollController = ScrollController();
  final ScrollController favoriteAnswerScrollController = ScrollController();

  final BehaviorSubject<User> userController =
      BehaviorSubject<User>.seeded(null);
  final BehaviorSubject<List<Answer>> createAnswersController =
      BehaviorSubject<List<Answer>>.seeded([]);
  final BehaviorSubject<List<Answer>> favoriteAnswersController =
      BehaviorSubject<List<Answer>>.seeded([]);

  void start() {
    createAnswerListSubscription?.cancel();
    createAnswerListSubscription =
        _userRepository.getCreateAnswersStream(userId: _userId).listen(
      (list) {
        list.sort((a, b) {
          return b.createdAt.compareTo(a.createdAt);
        });
        createAnswerEntityList = list;
        createAnswerScrollController.addListener(() {
          final maxScrollExtent =
              createAnswerScrollController.position.maxScrollExtent;
          final currentPosition = createAnswerScrollController.position.pixels;
          if (maxScrollExtent > 0 &&
              (maxScrollExtent - 20.0) <= currentPosition) {
            getCreateAnswers(
              userId: _userId,
              lastAnswer: createAnswersController.value.last,
            );
          }
        });
        createAnswersController.sink.add([]);
        getCreateAnswers(
          userId: _userId,
          lastAnswer: null,
        );
      },
    );

    favoriteAnswerListSubscription?.cancel();
    favoriteAnswerListSubscription =
        _userRepository.getFavoriteAnswersStream(userId: _userId).listen(
      (list) {
        list.sort((a, b) {
          return b.favoredAt.compareTo(a.favoredAt);
        });
        favoriteAnswerEntityList = list;
        favoriteAnswerScrollController.addListener(() {
          final maxScrollExtent =
              favoriteAnswerScrollController.position.maxScrollExtent;
          final currentPosition =
              favoriteAnswerScrollController.position.pixels;
          if (maxScrollExtent > 0 &&
              (maxScrollExtent - 20.0) <= currentPosition) {
            getFavoriteAnswers(
              userId: _userId,
              lastAnswer: favoriteAnswersController.value.last,
            );
          }
        });
        favoriteAnswersController.sink.add([]);
        getFavoriteAnswers(
          userId: _userId,
          lastAnswer: null,
        );
      },
    );

    getUser(id: _userId);
  }

  void getUser({@required String id}) {
    _userRepository.getUserStream(userId: id).listen(
      (User user) {
        userController.sink.add(user);
      },
    );
  }

  Future<void> getCreateAnswers(
      {@required String userId, Answer lastAnswer}) async {
    var answers = createAnswersController.value;
    var startIndex = 0;
    if (lastAnswer != null) {
      for (var i = 0; i < createAnswerEntityList.length; i++) {
        if (createAnswerEntityList.elementAt(i).id == lastAnswer.id) {
          startIndex = i + 1;
        }
      }
    }
    for (var i = startIndex; i < startIndex + 20; i++) {
      if (i >= createAnswerEntityList.length) {
        continue;
      }
      final answerEntity = await _answerRepository.getAnswer(
        id: createAnswerEntityList.elementAt(i).id,
      );
      final topic = await _topicRepository.getTopic(id: answerEntity.topicId);
      final user =
          await _userRepository.getUser(userId: answerEntity.createdUser);
      final topicCreatedUser =
          await _userRepository.getUser(userId: topic.createdUser);

      final answer = Answer(
        id: answerEntity.id,
        text: answerEntity.text,
        createdAt: answerEntity.createdAt,
        rank: answerEntity.rank,
        topicId: topic.id,
        topicText: topic.text,
        topicImageUrl: topic.imageUrl,
        topicCreatedAt: topic.createdAt,
        topicCreatedUserId: topicCreatedUser.id,
        topicCreatedUserName: topicCreatedUser.name,
        topicCreatedUserImageUrl: topicCreatedUser.imageUrl,
        createdUserId: user.id,
        createdUserName: user.name,
        createdUserImageUrl: user.imageUrl,
      );

      answers.add(answer);
    }
    createAnswersController.sink.add(answers);
  }

  Future<void> getFavoriteAnswers(
      {@required String userId, Answer lastAnswer}) async {
    var answers = favoriteAnswersController.value;
    var startIndex = 0;
    if (lastAnswer != null) {
      for (var i = 0; i < favoriteAnswerEntityList.length; i++) {
        if (favoriteAnswerEntityList.elementAt(i).id == lastAnswer.id) {
          startIndex = i + 1;
        }
      }
    }
    for (var i = startIndex; i < startIndex + 20; i++) {
      if (i >= favoriteAnswerEntityList.length) {
        continue;
      }
      final answerEntity = await _answerRepository.getAnswer(
        id: favoriteAnswerEntityList.elementAt(i).id,
      );
      final topic = await _topicRepository.getTopic(id: answerEntity.topicId);
      final user =
          await _userRepository.getUser(userId: answerEntity.createdUser);
      final topicCreatedUser =
          await _userRepository.getUser(userId: topic.createdUser);

      final answer = Answer(
        id: answerEntity.id,
        text: answerEntity.text,
        createdAt: answerEntity.createdAt,
        rank: answerEntity.rank,
        topicId: topic.id,
        topicText: topic.text,
        topicImageUrl: topic.imageUrl,
        topicCreatedAt: topic.createdAt,
        topicCreatedUserId: topicCreatedUser.id,
        topicCreatedUserName: topicCreatedUser.name,
        topicCreatedUserImageUrl: topicCreatedUser.imageUrl,
        createdUserId: user.id,
        createdUserName: user.name,
        createdUserImageUrl: user.imageUrl,
      );

      answers.add(answer);
    }
    favoriteAnswersController.sink.add(answers);
  }

  Future<void> dispose() async {
    await userController.close();
    await createAnswersController.close();
    await favoriteAnswersController.close();
  }
}
