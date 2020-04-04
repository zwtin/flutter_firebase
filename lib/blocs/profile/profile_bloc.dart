import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/profile/profile_state.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc implements Bloc {
  ProfileBloc(
    this._userRepository,
    this._itemRepository,
    this._authenticationRepository,
  )   : assert(_userRepository != null),
        assert(_itemRepository != null),
        assert(_authenticationRepository != null) {
    start();
  }

  final UserRepository _userRepository;
  final ItemRepository _itemRepository;
  final AuthenticationRepository _authenticationRepository;

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
        currentUserController.sink.add(currentUser);
        getUser(id: currentUser.id);
        getCreateItems(id: currentUser.id);
        getFavoriteItems(id: currentUser.id);
      },
    );
  }

  void getUser({@required String id}) {
    _userRepository.getUserDetail(userId: id).listen(
      (User user) {
        userController.sink.add(user);
      },
    );
  }

  void getCreateItems({@required String id}) {
    _userRepository.getCreatedItemIds(userId: id).listen(
      (List<String> ids) {
        _itemRepository.getSelectedItemListStream(ids: ids).listen(
          (List<Item> items) {
            createItemsController.sink.add(items);
          },
        );
      },
    );
  }

  void getFavoriteItems({@required String id}) {
    _userRepository.getFavoriteItemIds(userId: id).listen(
      (List<String> ids) {
        _itemRepository.getSelectedItemListStream(ids: ids).listen(
          (List<Item> items) {
            favoriteItemsController.sink.add(items);
          },
        );
      },
    );
  }

  Future<void> signOut() async {
    await _authenticationRepository.signOut();
  }

  @override
  Future<void> dispose() async {
    await currentUserController.close();
    await userController.close();
    await createItemsController.close();
    await favoriteItemsController.close();
  }
}
