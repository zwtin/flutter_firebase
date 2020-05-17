import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/answer.dart';
import 'package:flutter_firebase/entities/answer_entity.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/repositories/answer_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventListBloc {
  EventListBloc(
    this._answerRepository,
    this._topicRepository,
    this._userRepository,
  )   : assert(_answerRepository != null),
        assert(_topicRepository != null),
        assert(_userRepository != null) {
    start();
  }

  final AnswerRepository _answerRepository;
  final TopicRepository _topicRepository;
  final UserRepository _userRepository;

  StreamSubscription<int> rootTransitionSubscription;
  StreamSubscription<int> popTransitionSubscription;
  StreamSubscription<int> newRegisterSubscription;

  final ScrollController newAnswerScrollController = ScrollController();
  final ScrollController popularAnswerScrollController = ScrollController();

  final BehaviorSubject<List<Answer>> newAnswerController =
      BehaviorSubject<List<Answer>>.seeded([]);
  final BehaviorSubject<List<Answer>> popularAnswerController =
      BehaviorSubject<List<Answer>>.seeded([]);

  Future<void> start() async {
    newAnswerScrollController.addListener(
      () {
        final maxScrollExtent =
            newAnswerScrollController.position.maxScrollExtent;
        final currentPosition = newAnswerScrollController.position.pixels;
        if (maxScrollExtent > 0 &&
            (maxScrollExtent - 20.0) <= currentPosition) {
          getNewAnswer(null);
        }
      },
    );

    popularAnswerScrollController.addListener(
      () {
        final maxScrollExtent =
            popularAnswerScrollController.position.maxScrollExtent;
        final currentPosition = popularAnswerScrollController.position.pixels;
        if (maxScrollExtent > 0 &&
            (maxScrollExtent - 20.0) <= currentPosition) {
          getNewAnswer(null);
        }
      },
    );

    getNewAnswer(null);
    getPopularAnswer(null);
  }

  Future<void> getNewAnswer(AnswerEntity lastAnswer) async {
    try {
      final answers = newAnswerController.value;
      final answersEntities =
          await _answerRepository.getNewAnswerList(lastAnswer);
      for (final answerEntity in answersEntities) {
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
      newAnswerController.sink.add(answers);
    } on Exception catch (error) {
      print(error.toString());
      return;
    }
  }

  Future<void> getPopularAnswer(AnswerEntity lastAnswer) async {
    try {
      final answers = popularAnswerController.value;
      final answersEntities =
          await _answerRepository.getPopularAnswerList(lastAnswer);
      for (final answerEntity in answersEntities) {
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
      popularAnswerController.sink.add(answers);
    } on Exception catch (error) {
      print(error.toString());
      return;
    }
  }

  Future<void> reset() async {
    newAnswerController.sink.add([]);
    popularAnswerController.sink.add([]);
  }

  Future<void> dispose() async {
    await rootTransitionSubscription.cancel();
    await popTransitionSubscription.cancel();
    await newRegisterSubscription.cancel();
    await newAnswerController.close();
    await popularAnswerController.close();
  }
}
