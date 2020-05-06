import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/repositories/like_repository.dart';

class FirestoreLikeRepository implements LikeRepository {
  final _firestore = Firestore.instance;

  @override
  Future<bool> checkLike({
    @required String userId,
    @required String itemId,
  }) async {
    final liked = await _firestore
        .collection('users')
        .document(userId)
        .collection('like_items')
        .document(itemId)
        .get()
        .then(
      (document) {
        return document.exists;
      },
    );
    return liked;
  }

  @override
  Stream<bool> getLike({
    @required String userId,
    @required String itemId,
  }) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection('like_items')
        .document(itemId)
        .snapshots()
        .map(
      (DocumentSnapshot snapshot) {
        return snapshot.exists;
      },
    );
  }

  @override
  Future<void> setLike({
    @required String userId,
    @required String itemId,
  }) async {
    final itemMap = {'id': itemId};
    final userMap = {'id': userId};
    final batch = _firestore.batch()
      ..setData(
        _firestore
            .collection('users')
            .document(userId)
            .collection('like_items')
            .document(itemId),
        itemMap,
      )
      ..setData(
        _firestore
            .collection('items')
            .document(itemId)
            .collection('liked_users')
            .document(userId),
        userMap,
      );
    await batch.commit();
  }

  @override
  Future<void> removeLike({
    @required String userId,
    @required String itemId,
  }) async {
    final batch = _firestore.batch()
      ..delete(
        _firestore
            .collection('users')
            .document(userId)
            .collection('like_items')
            .document(itemId),
      )
      ..delete(
        _firestore
            .collection('items')
            .document(itemId)
            .collection('liked_users')
            .document(userId),
      );
    await batch.commit();
  }
}
