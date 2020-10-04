import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase/blocs/event_list_bloc.dart';
import 'package:flutter_firebase/blocs/my_profile_bloc.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_answer_repository.dart';
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:flutter_firebase/models/firestore_topic_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/my_profile_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/screens/event_list_screen.dart';

class TabBloc {
  // コンストラクタ
  TabBloc() {
    // DynamicLinkを設定
    initDynamicLinks();

    // プッシュ通知を設定
    setupPushNotification();
  }

  // インデックス0のタブ
  final Navigator tab0 = Navigator(
    // ルート画面生成
    onGenerateRoute: (RouteSettings settings) {
      return PageRouteBuilder<Widget>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
        ) {
          // 中身はProvider
          return Provider<EventListBloc>(
            // EventListBlocを提供
            create: (BuildContext context) {
              return EventListBloc(
                FirestoreAnswerRepository(),
                FirestoreTopicRepository(),
                FirestoreUserRepository(),
              );
            },

            // 画面破棄時
            dispose: (BuildContext context, EventListBloc bloc) {
              bloc.dispose();
            },

            //　表示画面
            child: EventListScreen(),
          );
        },
      );
    },
  );

  // インデックス1のタブ
  final Navigator tab1 = Navigator(
    // ルート画面生成
    onGenerateRoute: (RouteSettings settings) {
      return PageRouteBuilder<Widget>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
        ) {
          // 中身はProvider
          return Provider<MyProfileBloc>(
            // MyProfileBlocを提供
            create: (BuildContext context) {
              return MyProfileBloc(
                FirestoreUserRepository(),
                FirestoreAnswerRepository(),
                FirestoreTopicRepository(),
                FirestorePushNotificationRepository(),
                FirebaseAuthenticationRepository(),
              );
            },

            // 画面破棄時
            dispose: (BuildContext context, MyProfileBloc bloc) {
              bloc.dispose();
            },

            // 表示画面
            child: MyProfileScreen(),
          );
        },
      );
    },
  );

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final BehaviorSubject<int> indexController = BehaviorSubject<int>.seeded(0);
  final PublishSubject<int> rootTransitionController = PublishSubject<int>();
  final PublishSubject<int> popTransitionController = PublishSubject<int>();
  final PublishSubject<int> newRegisterController = PublishSubject<int>();

  // DynamicLinksの設定
  Future<void> initDynamicLinks() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink.path);
      newRegisterController.sink.add(indexController.value);
      rootTransitionController.sink.add(indexController.value);
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final deepLink = dynamicLink?.link;

        if (deepLink != null) {
          final query = deepLink.queryParameters;
          final apiKey = query['apiKey'];
          final mode = query['mode'];
          final oobCode = query['oobCode'];

//          final prefs = await SharedPreferences.getInstance();
//          final inputEmail = prefs.getString('email');
//          if (inputEmail != null) {
//            openNewRegister();
//          }
          newRegisterController.sink.add(indexController.value);
          rootTransitionController.sink.add(indexController.value);
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  // プッシュ通知の設定
  Future<void> setupPushNotification() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }

  // タブ押下時
  void tabTappedAction(int index) {
    if (indexController.value == index) {
      // 押下されたタブがすでに選択済みだった場合は、ルート画面に戻る
      rootTransitionController.sink.add(index);
    } else {
      // 押下されたタブが選択されていなかった場合は、選択済みタブに設定
      indexController.sink.add(index);
    }
  }

  // 戻るアクション
  Future<void> popAction() async {
    if (indexController.value == 0) {
      // 戻るStreamにイベントを流す（アクションは画面側で設定）
      popTransitionController.sink.add(0);
    } else if (indexController.value == 1) {
      // 戻るStreamにイベントを流す（アクションは画面側で設定）
      popTransitionController.sink.add(1);
    }
  }

  // 破棄時
  Future<void> dispose() async {
    await indexController.close();
    await rootTransitionController.close();
    await popTransitionController.close();
    await newRegisterController.close();
  }
}
