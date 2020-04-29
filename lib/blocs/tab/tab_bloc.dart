import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBloc {
  TabBloc(
    this._firebaseAuthenticationRepository,
    this._firestorePushNotificationRepository,
  )   : assert(_firebaseAuthenticationRepository != null),
        assert(_firestorePushNotificationRepository != null) {
    initDynamicLinks();
    setupPushNotification();
    registerDeviceTokenController.stream.listen((_) {
      registerDeviceToken();
    });
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final BehaviorSubject<int> indexController = BehaviorSubject<int>.seeded(0);
  final PublishSubject<int> rootTransitionController = PublishSubject<int>();
  final PublishSubject<int> newRegisterController = PublishSubject<int>();
  final PublishSubject<void> registerDeviceTokenController =
      PublishSubject<void>();

  final FirestorePushNotificationRepository
      _firestorePushNotificationRepository;
  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository;

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

  Future<void> registerDeviceToken() async {
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ),
    );
    _firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {},
    );
    try {
      final token = await _firebaseMessaging.getToken();
      final currentUser =
          await _firebaseAuthenticationRepository.getCurrentUser();
      await _firestorePushNotificationRepository.registerDeviceToken(
        userId: currentUser.id,
        deviceToken: token,
      );
    } on Exception catch (error) {}
  }

  Future<void> setupPushNotification() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
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

  Future<void> dispose() async {
    await indexController.close();
    await rootTransitionController.close();
    await newRegisterController.close();
    await registerDeviceTokenController.close();
  }
}
