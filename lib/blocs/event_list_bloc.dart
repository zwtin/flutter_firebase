import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/repositories/sample_repository.dart';
import 'package:flutter_firebase/use_cases/answer.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_firebase/entities/parameters/get_new_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/parameters/get_popular_answer_list_parameter.dart';

class EventListBloc {
  // コンストラクタ
  EventListBloc(
    this._topicRepository,
    this._userRepository,
    this._sampleRepository,
  )   : assert(_topicRepository != null),
        assert(_userRepository != null),
        assert(_sampleRepository != null) {
    start();
  }

  final TopicRepository _topicRepository;
  final UserRepository _userRepository;
  final SampleRepository _sampleRepository;

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

  final BehaviorSubject<Tuple2<List<Answer>, bool>> newAnswerController =
      BehaviorSubject<Tuple2<List<Answer>, bool>>.seeded(
    Tuple2<List<Answer>, bool>([], true),
  );

  final BehaviorSubject<Tuple2<List<Answer>, bool>> popularAnswerController =
      BehaviorSubject<Tuple2<List<Answer>, bool>>.seeded(
    Tuple2<List<Answer>, bool>([], true),
  );

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
          getNewAnswer();
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
          getPopularAnswer();
        }
      },
    );

    // 新着順を取得
    await getNewAnswer();

    // 人気順を取得
    await getPopularAnswer();
  }

  // 一番古い回答よりも古い回答を取得
  Future<void> getNewAnswer() async {
    try {
      // 読込中は何もしない
      if (isNewAnswerLoading) {
        return;
      }

      // 読込中に設定
      isNewAnswerLoading = true;

      // 取得済みの回答をセット
      final answers = newAnswerController.value.item1;

      // 回答取得のためのパラメータを生成
      final getNewAnswerListParameter = GetNewAnswerListParameter(
        createdAt: answers.isNotEmpty ? answers.last.answerCreatedAt : null,
      );

      // 回答を取得
      final getNewAnswerListResponse = await _sampleRepository.getNewAnswerList(
        parameter: getNewAnswerListParameter,
      );

      // 回答のお題や投稿者を取得
      for (var answer in getNewAnswerListResponse.answers) {
        final topic = await _topicRepository.getTopic(id: answer.topicId);
        final createUser =
            await _userRepository.getUser(userId: answer.answerCreatedUserId);
        final topicCreatedUser =
            await _userRepository.getUser(userId: topic.createdUser);

        answer
          ..answerId = answer.answerId
          ..answerText = answer.answerText
          ..answerCreatedAt = answer.answerCreatedAt
          ..answerPoint = answer.answerPoint
          ..topicId = answer.topicId
          ..answerCreatedUserId = answer.answerCreatedUserId
          ..topicText = topic.text
          ..topicImageUrl = topic.imageUrl
          ..topicCreatedAt = topic.createdAt
          ..topicCreatedUserId = topic.createdUser
          ..answerCreatedUserName = createUser.name
          ..answerCreatedUserImageUrl = createUser.imageUrl
          ..topicCreatedUserName = topicCreatedUser.name
          ..topicCreatedUserImageUrl = topicCreatedUser.imageUrl;

        answers.add(answer);
      }

      // Sinkにイベントを流す
      newAnswerController.sink.add(
        Tuple2<List<Answer>, bool>(
          answers,
          getNewAnswerListResponse.hasNext,
        ),
      );

      // 通信終了
      isNewAnswerLoading = false;
    }
    // エラー時
    on Exception catch (error) {
      print(error.toString());
      isNewAnswerLoading = false;
      return;
    }
  }

  // 一番低いrankよりも低い回答を取得
  Future<void> getPopularAnswer() async {
    try {
      // 読込中は何もしない
      if (isPopularAnswerLoading) {
        return;
      }

      // 読込中に設定
      isPopularAnswerLoading = true;

      // 取得済みの回答をセット
      final answers = popularAnswerController.value.item1;

      // 回答取得のためのパラメータを生成
      final getPopularAnswerListParameter = GetPopularAnswerListParameter(
        rank: answers.isNotEmpty ? answers.last.answerPoint : null,
      );

      // 回答を取得
      final getPopularAnswerListResponse =
          await _sampleRepository.getPopularAnswerList(
        parameter: getPopularAnswerListParameter,
      );

      // 回答のお題や投稿者を取得
      for (var answer in getPopularAnswerListResponse.answers) {
        final topic = await _topicRepository.getTopic(id: answer.topicId);
        final user =
            await _userRepository.getUser(userId: answer.answerCreatedUserId);
        final topicCreatedUser =
            await _userRepository.getUser(userId: topic.createdUser);

        answer
          ..answerId = answer.answerId
          ..answerText = answer.answerText
          ..answerCreatedAt = answer.answerCreatedAt
          ..answerPoint = answer.answerPoint
          ..topicId = answer.topicId
          ..answerCreatedUserId = answer.answerCreatedUserId
          ..topicText = topic.text
          ..topicImageUrl = topic.imageUrl
          ..topicCreatedAt = topic.createdAt
          ..topicCreatedUserId = topic.createdUser
          ..answerCreatedUserName = user.name
          ..answerCreatedUserImageUrl = user.imageUrl
          ..topicCreatedUserName = topicCreatedUser.name
          ..topicCreatedUserImageUrl = topicCreatedUser.imageUrl;

        answers.add(answer);
      }

      // Sinkにイベントを流す
      popularAnswerController.sink.add(
        Tuple2<List<Answer>, bool>(
          answers,
          getPopularAnswerListResponse.hasNext,
        ),
      );

      // 通信終了
      isPopularAnswerLoading = false;
    }
    // エラー時
    on Exception catch (error) {
      print(error.toString());
      isPopularAnswerLoading = false;
      return;
    }
  }

  Future<void> newAnswerControllerReset() async {
    newAnswerController.sink.add(Tuple2<List<Answer>, bool>([], false));
    await getNewAnswer();
  }

  Future<void> popularAnswerControllerReset() async {
    popularAnswerController.sink.add(Tuple2<List<Answer>, bool>([], false));
    await getPopularAnswer();
  }

  Future<void> dispose() async {
    await rootTransitionSubscription.cancel();
    await popTransitionSubscription.cancel();
    await newRegisterSubscription.cancel();
    await newAnswerController.close();
    await popularAnswerController.close();
  }
}
