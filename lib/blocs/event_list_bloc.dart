import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/use_cases/answer.dart';
import 'package:flutter_firebase/use_cases/answer_entity.dart';
import 'package:flutter_firebase/repositories/answer_repository.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventListBloc {
  // コンストラクタ
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

  // ルート画面へ戻るイベント購読用
  StreamSubscription<int> rootTransitionSubscription;
  // 戻るイベント購読用
  StreamSubscription<int> popTransitionSubscription;
  // 新規会員登録イベント購読用
  StreamSubscription<int> newRegisterSubscription;

  bool isNewAnswerLoading = false; // 新着順回答読み込み中
  bool isPopularAnswerLoading = false; // 新着順回答読み込み中

  // 新着順回答のスクロール量検知用
  final ScrollController newAnswerScrollController = ScrollController();
  // 人気順回答のスクロール量検知用
  final ScrollController popularAnswerScrollController = ScrollController();

  final BehaviorSubject<List<Answer>> newAnswerController =
      BehaviorSubject<List<Answer>>.seeded([]);
  final BehaviorSubject<List<Answer>> popularAnswerController =
      BehaviorSubject<List<Answer>>.seeded([]);

  Future<void> start() async {
    // 新着順のスクロールを検知
    newAnswerScrollController.addListener(
      () {
        // 最大スクロール量
        final maxScrollExtent =
            newAnswerScrollController.position.maxScrollExtent;
        // 現在のスクロール量
        final currentPosition = newAnswerScrollController.position.pixels;

        // ある程度のスクロール量で、読み込み開始
        if (maxScrollExtent > 0 &&
            (maxScrollExtent - 300.0) <= currentPosition) {
          getNewAnswer(newAnswerController.value.last);
        }
      },
    );

    // 人気順のスクロールを検知
    popularAnswerScrollController.addListener(
      () {
        // 最大スクロール量
        final maxScrollExtent =
            popularAnswerScrollController.position.maxScrollExtent;
        // 現在のスクロール量
        final currentPosition = popularAnswerScrollController.position.pixels;

        // ある程度のスクロール量で、読み込み開始
        if (maxScrollExtent > 0 &&
            (maxScrollExtent - 300.0) <= currentPosition) {
          getPopularAnswer(popularAnswerController.value.last);
        }
      },
    );

    // 新着順を取得
    await getNewAnswer(null);

    // 人気順を取得
    await getPopularAnswer(null);
  }

  // lastAnswerよりも
  Future<void> getNewAnswer(Answer lastAnswer) async {
    try {
      // 読込中は何もしない
      if (isNewAnswerLoading) {
        return;
      }

      // 読込中に設定
      isNewAnswerLoading = true;

      // 取得済みの回答をセット
      final answers = newAnswerController.value;

      if (lastAnswer == null) {
        // lastAnswerがnullの場合
        final answersEntities = await _answerRepository.getNewAnswerList(null);

        for (final answerEntity in answersEntities) {
          final topic =
              await _topicRepository.getTopic(id: answerEntity.topicId);
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
        isNewAnswerLoading = false;
      } else {
        // lastAnswerがある場合
        final lastAnswerEntity = AnswerEntity(
          id: lastAnswer.id,
          text: lastAnswer.text,
          createdAt: lastAnswer.createdAt,
          rank: lastAnswer.rank,
          topicId: lastAnswer.topicId,
          createdUser: lastAnswer.createdUserId,
        );
        final answersEntities =
            await _answerRepository.getNewAnswerList(lastAnswerEntity);

        for (final answerEntity in answersEntities) {
          final topic =
              await _topicRepository.getTopic(id: answerEntity.topicId);
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
        isNewAnswerLoading = false;
      }
    } on Exception catch (error) {
      print(error.toString());
      isNewAnswerLoading = false;
      return;
    }
  }

  Future<void> getPopularAnswer(Answer lastAnswer) async {
    try {
      if (isPopularAnswerLoading) {
        return;
      }
      isPopularAnswerLoading = true;
      final answers = popularAnswerController.value;
      if (lastAnswer == null) {
        final answersEntities =
            await _answerRepository.getPopularAnswerList(null);
        for (final answerEntity in answersEntities) {
          final topic =
              await _topicRepository.getTopic(id: answerEntity.topicId);
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
        isPopularAnswerLoading = false;
      } else {
        final lastAnswerEntity = AnswerEntity(
          id: lastAnswer.id,
          text: lastAnswer.text,
          createdAt: lastAnswer.createdAt,
          rank: lastAnswer.rank,
          topicId: lastAnswer.topicId,
          createdUser: lastAnswer.createdUserId,
        );
        final answersEntities =
            await _answerRepository.getPopularAnswerList(lastAnswerEntity);
        for (final answerEntity in answersEntities) {
          final topic =
              await _topicRepository.getTopic(id: answerEntity.topicId);
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
        isPopularAnswerLoading = false;
      }
    } on Exception catch (error) {
      print(error.toString());
      isPopularAnswerLoading = false;
      return;
    }
  }

  Future<void> newAnswerControllerReset() async {
    newAnswerController.sink.add([]);
    await getNewAnswer(null);
  }

  Future<void> popularAnswerControllerReset() async {
    popularAnswerController.sink.add([]);
    await getPopularAnswer(null);
  }

  Future<void> dispose() async {
    await rootTransitionSubscription.cancel();
    await popTransitionSubscription.cancel();
    await newRegisterSubscription.cancel();
    await newAnswerController.close();
    await popularAnswerController.close();
  }
}
