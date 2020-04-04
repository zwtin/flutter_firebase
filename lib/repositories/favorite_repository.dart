import 'package:flutter/material.dart';

abstract class FavoriteRepository {
  Future<bool> checkFavorite({
    @required String userId,
    @required String itemId,
  });

  Stream<bool> getFavorite({
    @required String userId,
    @required String itemId,
  });

  Future<void> setFavorite({
    @required String userId,
    @required String itemId,
  });

  Future<void> removeFavorite({
    @required String userId,
    @required String itemId,
  });
}
