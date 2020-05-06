import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:flutter_firebase/repositories/push_notification_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  ProfileBloc(
    this._userRepository,
    this._itemRepository,
    this._pushNotificationRepository,
    this._authenticationRepository,
  )   : assert(_userRepository != null),
        assert(_itemRepository != null),
        assert(_pushNotificationRepository != null),
        assert(_authenticationRepository != null) {
    start();
  }

  final UserRepository _userRepository;
  final ItemRepository _itemRepository;
  final PushNotificationRepository _pushNotificationRepository;
  final AuthenticationRepository _authenticationRepository;

  StreamSubscription<int> rootTransitionSubscription;
  StreamSubscription<int> popTransitionSubscription;
  StreamSubscription<int> newRegisterSubscription;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final BehaviorSubject<CurrentUser> currentUserController =
      BehaviorSubject<CurrentUser>.seeded(null);
  final BehaviorSubject<User> userController =
      BehaviorSubject<User>.seeded(null);
  final BehaviorSubject<List<Item>> createItemsController =
      BehaviorSubject<List<Item>>.seeded([]);
  final BehaviorSubject<List<Item>> favoriteItemsController =
      BehaviorSubject<List<Item>>.seeded([]);

  void start() {
    _authenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        if (currentUser == null) {
          currentUserController.sink.add(null);
        } else {
          currentUserController.sink.add(currentUser);
          getUser(id: currentUser.id);
          getCreateItems(id: currentUser.id);
          getFavoriteItems(id: currentUser.id);
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

  void getCreateItems({@required String id}) {
    _userRepository.getCreatedItemIds(userId: id).listen(
      (List<String> ids) {
        if (ids.isEmpty) {
          createItemsController.sink.add([]);
        } else {
          _itemRepository.getSelectedItemListStream(ids: ids).listen(
            (List<Item> items) {
              createItemsController.sink.add(items);
            },
          );
        }
      },
    );
  }

  void getFavoriteItems({@required String id}) {
    _userRepository.getFavoriteItemIds(userId: id).listen(
      (List<String> ids) {
        if (ids.isEmpty) {
          favoriteItemsController.sink.add([]);
        } else {
          _itemRepository.getSelectedItemListStream(ids: ids).listen(
            (List<Item> items) {
              favoriteItemsController.sink.add(items);
            },
          );
        }
      },
    );
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
    await currentUserController.close();
    await userController.close();
    await createItemsController.close();
    await favoriteItemsController.close();
  }
}
