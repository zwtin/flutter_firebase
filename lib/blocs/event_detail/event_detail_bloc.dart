import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_state.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/favorite_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:flutter_firebase/repositories/like_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventDetailBloc implements Bloc {
  EventDetailBloc(
    this.id,
    this._itemRepository,
    this._likeRepository,
    this._favoriteRepository,
    this._authenticationRepository,
  )   : assert(id != null),
        assert(_itemRepository != null),
        assert(_likeRepository != null),
        assert(_favoriteRepository != null),
        assert(_authenticationRepository != null) {
    setup();
  }

  final String id;
  final ItemRepository _itemRepository;
  final LikeRepository _likeRepository;
  final FavoriteRepository _favoriteRepository;
  final AuthenticationRepository _authenticationRepository;

  final BehaviorSubject<Item> itemController =
      BehaviorSubject<Item>.seeded(null);
  final BehaviorSubject<bool> likeController =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> favoriteController =
      BehaviorSubject<bool>.seeded(false);

  void setup() {
    _itemRepository.getItemDetail(id: id).listen(
      (Item item) {
        itemController.sink.add(item);
      },
    );
    _authenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        if (currentUser == null) {
          likeController.sink.add(false);
          favoriteController.sink.add(false);
        } else {
          _likeRepository.getLike(userId: currentUser.id, itemId: id).listen(
            (bool isLiked) {
              likeController.sink.add(isLiked);
            },
          );
          _favoriteRepository
              .getFavorite(userId: currentUser.id, itemId: id)
              .listen(
            (bool isFavorite) {
              favoriteController.sink.add(isFavorite);
            },
          );
        }
      },
    );
  }

  Future<void> likeButtonAction() async {
    final currentUser = await _authenticationRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    if (likeController.value) {
      await _likeRepository.removeLike(userId: currentUser.id, itemId: id);
    } else {
      await _likeRepository.setLike(userId: currentUser.id, itemId: id);
    }
  }

  Future<void> favoriteButtonAction() async {
    final currentUser = await _authenticationRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    if (favoriteController.value) {
      await _favoriteRepository.removeFavorite(
          userId: currentUser.id, itemId: id);
    } else {
      await _favoriteRepository.setFavorite(userId: currentUser.id, itemId: id);
    }
  }

  @override
  Future<void> dispose() async {
    await itemController.close();
    await likeController.close();
    await favoriteController.close();
  }
}
