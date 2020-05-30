import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/answer.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/repositories/answer_repository.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:flutter_firebase/repositories/favorite_repository.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';
import 'package:flutter_firebase/repositories/like_repository.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventDetailBloc {
  EventDetailBloc(
    this._answer,
    this._likeRepository,
    this._favoriteRepository,
    this._authenticationRepository,
  )   : assert(_answer != null),
        assert(_likeRepository != null),
        assert(_favoriteRepository != null),
        assert(_authenticationRepository != null) {
    setup();
  }

  final Answer _answer;
  final LikeRepository _likeRepository;
  final FavoriteRepository _favoriteRepository;
  final AuthenticationRepository _authenticationRepository;

  final BehaviorSubject<Answer> answerController =
      BehaviorSubject<Answer>.seeded(null);
  final BehaviorSubject<int> likeCountController =
      BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<int> favoriteCountController =
      BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> likeController =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> favoriteController =
      BehaviorSubject<bool>.seeded(false);

  Future<void> setup() async {
    answerController.sink.add(_answer);

    _authenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        if (currentUser == null) {
          likeController.sink.add(false);
          favoriteController.sink.add(false);
        } else {
          _likeRepository
              .getLike(userId: currentUser.id, itemId: _answer.id)
              .listen(
            (bool isLiked) {
              likeController.sink.add(isLiked);
            },
          );
          _favoriteRepository
              .getFavorite(userId: currentUser.id, itemId: _answer.id)
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
      await _likeRepository.removeLike(
          userId: currentUser.id, itemId: _answer.id);
    } else {
      await _likeRepository.setLike(userId: currentUser.id, itemId: _answer.id);
    }
  }

  Future<void> favoriteButtonAction() async {
    final currentUser = await _authenticationRepository.getCurrentUser();
    if (currentUser == null) {
      return;
    }
    if (favoriteController.value) {
      await _favoriteRepository.removeFavorite(
          userId: currentUser.id, itemId: _answer.id);
    } else {
      await _favoriteRepository.setFavorite(
          userId: currentUser.id, itemId: _answer.id);
    }
  }

  Future<void> dispose() async {
    await answerController.close();
    await likeCountController.close();
    await favoriteCountController.close();
    await likeController.close();
    await favoriteController.close();
  }
}
