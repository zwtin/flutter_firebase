import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/answer.dart';
import 'package:flutter_firebase/entities/create_answer_entity.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/entities/favorite_answer_entity.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/repositories/answer_repository.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:flutter_firebase/repositories/push_notification_repository.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  ProfileBloc(
    this._userRepository,
    this._answerRepository,
    this._topicRepository,
    this._pushNotificationRepository,
    this._authenticationRepository,
  )   : assert(_userRepository != null),
        assert(_answerRepository != null),
        assert(_topicRepository != null),
        assert(_pushNotificationRepository != null),
        assert(_authenticationRepository != null) {
    start();
  }

  final UserRepository _userRepository;
  final AnswerRepository _answerRepository;
  final TopicRepository _topicRepository;
  final PushNotificationRepository _pushNotificationRepository;
  final AuthenticationRepository _authenticationRepository;

  StreamSubscription<int> rootTransitionSubscription;
  StreamSubscription<int> popTransitionSubscription;
  StreamSubscription<int> newRegisterSubscription;

  StreamSubscription<List<CreateAnswerEntity>> createAnswerListSubscription;
  List<CreateAnswerEntity> createAnswerEntityList = [];
  StreamSubscription<List<FavoriteAnswerEntity>> favoriteAnswerListSubscription;
  List<FavoriteAnswerEntity> favoriteAnswerEntityList = [];

  final ScrollController createAnswerScrollController = ScrollController();
  final ScrollController favoriteAnswerScrollController = ScrollController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final BehaviorSubject<User> userController =
      BehaviorSubject<User>.seeded(null);
  final BehaviorSubject<List<Answer>> createAnswersController =
      BehaviorSubject<List<Answer>>.seeded([]);
  final BehaviorSubject<List<Answer>> favoriteAnswersController =
      BehaviorSubject<List<Answer>>.seeded([]);

  void start() {
    _authenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        if (currentUser == null) {
          createAnswerListSubscription?.cancel();
          favoriteAnswerListSubscription?.cancel();
          userController.sink.add(null);
        } else {
          createAnswerListSubscription?.cancel();
          createAnswerListSubscription = _userRepository
              .getCreateAnswersStream(userId: currentUser.id)
              .listen(
            (list) {
              list.sort((a, b) {
                return b.createdAt.compareTo(a.createdAt);
              });
              createAnswerEntityList = list;
              createAnswerScrollController.addListener(() {
                final maxScrollExtent =
                    createAnswerScrollController.position.maxScrollExtent;
                final currentPosition =
                    createAnswerScrollController.position.pixels;
                if (maxScrollExtent > 0 &&
                    (maxScrollExtent - 20.0) <= currentPosition) {
                  getCreateAnswers(
                    userId: currentUser.id,
                    lastAnswer: createAnswersController.value.last,
                  );
                }
              });
              getCreateAnswers(
                userId: currentUser.id,
                lastAnswer: null,
              );
            },
          );

          favoriteAnswerListSubscription?.cancel();
          favoriteAnswerListSubscription = _userRepository
              .getFavoriteAnswersStream(userId: currentUser.id)
              .listen(
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
                    userId: currentUser.id,
                    lastAnswer: favoriteAnswersController.value.last,
                  );
                }
              });
              getCreateAnswers(
                userId: currentUser.id,
                lastAnswer: null,
              );
            },
          );

          getUser(id: currentUser.id);
        }
      },
    );
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

  Future<void> unregisterDeviceToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      final currentUser = await _authenticationRepository.getCurrentUser();
      await _pushNotificationRepository.unregisterDeviceToken(
        userId: currentUser.id,
        deviceToken: token,
      );
    } on Exception catch (error) {
      return;
    }
  }

  Future<void> signOut() async {
    await unregisterDeviceToken();
    await _authenticationRepository.signOut();
  }

  Future<void> dispose() async {
    await rootTransitionSubscription.cancel();
    await popTransitionSubscription.cancel();
    await newRegisterSubscription.cancel();
    await userController.close();
    await createAnswersController.close();
    await favoriteAnswersController.close();
  }
}
