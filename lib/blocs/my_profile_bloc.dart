import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/parameters/get_answer_parameter.dart';
import 'package:flutter_firebase/entities/parameters/get_user_create_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/parameters/get_user_favor_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/responses/get_user_create_answer_list_response.dart';
import 'package:flutter_firebase/repositories/sample_repository.dart';
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
import 'package:tuple/tuple.dart';

class MyProfileBloc {
  MyProfileBloc(
    this._userRepository,
    this._answerRepository,
    this._topicRepository,
    this._pushNotificationRepository,
    this._authenticationRepository,
    this._sampleRepository,
  )   : assert(_userRepository != null),
        assert(_answerRepository != null),
        assert(_topicRepository != null),
        assert(_pushNotificationRepository != null),
        assert(_authenticationRepository != null),
        assert(_sampleRepository != null) {
    start();
  }

  final UserRepository _userRepository;
  final AnswerRepository _answerRepository;
  final TopicRepository _topicRepository;
  final PushNotificationRepository _pushNotificationRepository;
  final AuthenticationRepository _authenticationRepository;
  final SampleRepository _sampleRepository;

  // プッシュ通知用
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // ルート画面へ戻るイベント購読用
  StreamSubscription<int> rootTransitionSubscription;
  // 戻るイベント購読用
  StreamSubscription<int> popTransitionSubscription;
  // 新規会員登録イベント購読用
  StreamSubscription<int> newRegisterSubscription;

  // ユーザー情報購読用（startで代入している）
  StreamSubscription<User> userSubscription;

  bool isUserCreateAnswerLoading = false; // 投稿した回答読み込み中
  bool isUserFavorAnswerLoading = false; // お気に入り回答読み込み中

  // 投稿した回答のスクロール量検知用
  final ScrollController userCreateAnswerScrollController = ScrollController();
  // お気に入り回答のスクロール量検知用
  final ScrollController userFavorAnswerScrollController = ScrollController();

  // ユーザー情報詳細
  final BehaviorSubject<User> userController =
      BehaviorSubject<User>.seeded(null);

  // 投稿した回答
  final BehaviorSubject<Tuple2<List<Answer>, bool>>
      userCreateAnswersController =
      BehaviorSubject<Tuple2<List<Answer>, bool>>.seeded(
    Tuple2<List<Answer>, bool>([], true),
  );

  // お気に入り回答
  final BehaviorSubject<Tuple2<List<Answer>, bool>> userFavorAnswersController =
      BehaviorSubject<Tuple2<List<Answer>, bool>>.seeded(
    Tuple2<List<Answer>, bool>([], true),
  );

  Future<void> start() async {
    _authenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        if (currentUser != null) {
          // ログイン時
          userSubscription = _userRepository
              .getUserStream(userId: currentUser.id)
              .listen((User user) {
            // ユーザー情報のイベントを流す
            userController.sink.add(user);
          });
          registerDeviceToken(userId: currentUser.id);
        } else {
          // ログアウト時
          userSubscription?.cancel();
          unregisterDeviceToken(userId: userController.value.id);
          userController.sink.add(null);
        }
      },
    );

    userController.stream.listen((User user) {
      getUserCreateAnswer();
      getUserFavorAnswer();
    });

    userCreateAnswerScrollController.addListener(
      () {
        // 最大スクロール量
        final maxScrollExtent =
            userCreateAnswerScrollController.position.maxScrollExtent;
        // 現在のスクロール量
        final currentPosition =
            userCreateAnswerScrollController.position.pixels;

        // ある程度のスクロール量で、読み込み開始
        if (maxScrollExtent > 0 &&
            (maxScrollExtent - 300.0) <= currentPosition) {
          getUserCreateAnswer();
        }
      },
    );

    // 人気順のスクロールを検知
    userFavorAnswerScrollController.addListener(
      () {
        // 最大スクロール量
        final maxScrollExtent =
            userFavorAnswerScrollController.position.maxScrollExtent;
        // 現在のスクロール量
        final currentPosition = userFavorAnswerScrollController.position.pixels;

        // ある程度のスクロール量で、読み込み開始
        if (maxScrollExtent > 0 &&
            (maxScrollExtent - 300.0) <= currentPosition) {
          getUserFavorAnswer();
        }
      },
    );
  }

  Future<void> registerDeviceToken({@required String userId}) async {
    try {
      final token = await _firebaseMessaging.getToken();
      await _pushNotificationRepository.registerDeviceToken(
        userId: userId,
        deviceToken: token,
      );
    } on Exception catch (error) {
      return;
    }
  }

  Future<void> unregisterDeviceToken({@required String userId}) async {
    try {
      final token = await _firebaseMessaging.getToken();
      await _pushNotificationRepository.unregisterDeviceToken(
        userId: userId,
        deviceToken: token,
      );
    } on Exception catch (error) {
      return;
    }
  }

  // ログアウト
  Future<void> signOut() async {
    await _authenticationRepository.signOut();
  }

  // dateTimeよりも古い回答を取得
  Future<void> getUserCreateAnswer() async {
    try {
      // 読込中は何もしない
      if (isUserCreateAnswerLoading) {
        return;
      }

      if (userController.value == null) {
        return;
      }

      // 読込中に設定
      isUserCreateAnswerLoading = true;

      // 取得済みの回答をセット
      final answers = userCreateAnswersController.value.item1;

      // 回答取得のためのパラメータを生成
      final getUserCreateAnswerListParameter = GetUserCreateAnswerListParameter(
        userId: userController.value.id,
        createdAt: answers.isNotEmpty ? answers.last.answerCreatedAt : null,
      );

      // 回答を取得
      final getUserCreateAnswerListResponse =
          await _sampleRepository.getUserCreateAnswerList(
        parameter: getUserCreateAnswerListParameter,
      );

      // 回答のお題や投稿者を取得
      for (var answer in getUserCreateAnswerListResponse.answers) {
        final getAnswerParameter = GetAnswerParameter(
          id: answer.answerId,
        );
        final answerDetail =
            await _sampleRepository.getAnswer(parameter: getAnswerParameter);
        final topic =
            await _topicRepository.getTopic(id: answerDetail.answer.topicId);
        final user = await _userRepository.getUser(
            userId: answerDetail.answer.answerCreatedUserId);
        final topicCreatedUser =
            await _userRepository.getUser(userId: topic.createdUser);

        answer
          ..answerId = answerDetail.answer.answerId
          ..answerText = answerDetail.answer.answerText
          ..answerCreatedAt = answerDetail.answer.answerCreatedAt
          ..answerPoint = answerDetail.answer.answerPoint
          ..topicId = answerDetail.answer.topicId
          ..answerCreatedUserId = answerDetail.answer.answerCreatedUserId
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
      userCreateAnswersController.sink.add(
        Tuple2<List<Answer>, bool>(
          answers,
          getUserCreateAnswerListResponse.hasNext,
        ),
      );

      // 通信終了
      isUserCreateAnswerLoading = false;
    }
    // エラー時
    on Exception catch (error) {
      print(error.toString());
      isUserCreateAnswerLoading = false;
      return;
    }
  }

  // userIdがお気に入りした、dateTimeよりも古い回答を取得
  Future<void> getUserFavorAnswer() async {
    try {
      // 読込中は何もしない
      if (isUserFavorAnswerLoading) {
        return;
      }

      if (userController.value == null) {
        return;
      }

      // 読込中に設定
      isUserFavorAnswerLoading = true;

      // 取得済みの回答をセット
      final answers = userFavorAnswersController.value.item1;

      // 回答取得のためのパラメータを生成
      final getUserFavorAnswerListParameter = GetUserFavorAnswerListParameter(
        userId: userController.value.id,
        favorAt: answers.isNotEmpty ? answers.last.answerFavoredAt : null,
      );

      // 回答を取得
      final getUserFavorAnswerListResponse =
          await _sampleRepository.getUserFavorAnswerList(
        parameter: getUserFavorAnswerListParameter,
      );

      // 回答のお題や投稿者を取得
      for (var answer in getUserFavorAnswerListResponse.answers) {
        final getAnswerParameter = GetAnswerParameter(
          id: answer.answerId,
        );
        final answerDetail =
            await _sampleRepository.getAnswer(parameter: getAnswerParameter);
        final topic =
            await _topicRepository.getTopic(id: answerDetail.answer.topicId);
        final user = await _userRepository.getUser(
            userId: answerDetail.answer.answerCreatedUserId);
        final topicCreatedUser =
            await _userRepository.getUser(userId: topic.createdUser);

        answer
          ..answerId = answerDetail.answer.answerId
          ..answerText = answerDetail.answer.answerText
          ..answerCreatedAt = answerDetail.answer.answerCreatedAt
          ..answerFavoredAt = answer.answerFavoredAt
          ..answerPoint = answerDetail.answer.answerPoint
          ..topicId = answerDetail.answer.topicId
          ..answerCreatedUserId = answerDetail.answer.answerCreatedUserId
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
      userFavorAnswersController.sink.add(
        Tuple2<List<Answer>, bool>(
          answers,
          getUserFavorAnswerListResponse.hasNext,
        ),
      );

      // 通信終了
      isUserFavorAnswerLoading = false;
    }
    // エラー時
    on Exception catch (error) {
      print(error.toString());
      isUserFavorAnswerLoading = false;
      return;
    }
  }

  // 投稿した回答再読み込み
  Future<void> userCreateAnswerControllerReset() async {
    userCreateAnswersController.sink.add(Tuple2<List<Answer>, bool>([], false));
    await getUserCreateAnswer();
  }

  // お気に入り回答再読み込み
  Future<void> userFavorAnswerControllerReset() async {
    userFavorAnswersController.sink.add(Tuple2<List<Answer>, bool>([], false));
    await getUserFavorAnswer();
  }

  Future<void> dispose() async {
    await rootTransitionSubscription.cancel();
    await popTransitionSubscription.cancel();
    await newRegisterSubscription.cancel();
    await userController.close();
    await userCreateAnswersController.close();
    await userFavorAnswersController.close();
  }
}
