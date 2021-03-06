import 'package:flutter/material.dart';

abstract class LikeRepository {
  Future<bool> checkLike({
    @required String userId,
    @required String itemId,
  });

  Stream<bool> getLike({
    @required String userId,
    @required String itemId,
  });

  Future<void> setLike({
    @required String userId,
    @required String itemId,
  });

  Future<void> removeLike({
    @required String userId,
    @required String itemId,
  });
}
