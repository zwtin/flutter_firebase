import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase/blocs/event_list_bloc.dart';
import 'package:flutter_firebase/blocs/profile_bloc.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/profile_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/screens/event_list_screen.dart';

class TabBloc {
  TabBloc() {
    initDynamicLinks();
    setupPushNotification();
  }

  final Navigator tab0 = Navigator(
    onGenerateRoute: (RouteSettings settings) {
      return PageRouteBuilder<Widget>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
        ) {
          return Provider<EventListBloc>(
            create: (BuildContext context) {
              return EventListBloc(
                FirestoreItemRepository(),
              );
            },
            dispose: (BuildContext context, EventListBloc bloc) {
              bloc.dispose();
            },
            child: EventListScreen(),
          );
        },
      );
    },
  );

  final Navigator tab1 = Navigator(
    onGenerateRoute: (RouteSettings settings) {
      return PageRouteBuilder<Widget>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
        ) {
          return Provider<ProfileBloc>(
            create: (BuildContext context) {
              return ProfileBloc(
                FirestoreUserRepository(),
                FirestoreItemRepository(),
                FirebaseAuthenticationRepository(),
              );
            },
            dispose: (BuildContext context, ProfileBloc bloc) {
              bloc.dispose();
            },
            child: ProfileScreen(),
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

  void tabTappedAction(int index) {
    if (indexController.value == index) {
      rootTransitionController.sink.add(index);
    } else {
      indexController.sink.add(index);
    }
  }

  Future<void> popAction() async {
    if (indexController.value == 0) {
      popTransitionController.sink.add(0);
    } else if (indexController.value == 1) {
      popTransitionController.sink.add(1);
    }
  }

  Future<void> dispose() async {
    await indexController.close();
    await rootTransitionController.close();
    await popTransitionController.close();
    await newRegisterController.close();
  }
}
