import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/repositories/favorite_repository.dart';

class FirestoreFavoriteRepository implements FavoriteRepository {
  final _firestore = Firestore.instance;

  @override
  Future<bool> checkFavorite({
    @required String userId,
    @required String itemId,
  }) async {
    final liked = await _firestore
        .collection('users')
        .document(userId)
        .collection('favorite_answers')
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
  Stream<bool> getFavorite({
    @required String userId,
    @required String itemId,
  }) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection('favorite_answers')
        .document(itemId)
        .snapshots()
        .map(
      (DocumentSnapshot snapshot) {
        return snapshot.exists;
      },
    );
  }

  @override
  Future<void> setFavorite({
    @required String userId,
    @required String itemId,
  }) async {
    final userMap = {'id': userId, 'favored_at': FieldValue.serverTimestamp()};
    final itemMap = {'id': itemId, 'favor_at': FieldValue.serverTimestamp()};
    final batch = _firestore.batch()
      ..setData(
        _firestore
            .collection('users')
            .document(userId)
            .collection('favorite_answers')
            .document(itemId),
        itemMap,
      )
      ..setData(
        _firestore
            .collection('answers')
            .document(itemId)
            .collection('favorited_users')
            .document(userId),
        userMap,
      );
    await batch.commit();
  }

  @override
  Future<void> removeFavorite({
    @required String userId,
    @required String itemId,
  }) async {
    final batch = _firestore.batch()
      ..delete(
        _firestore
            .collection('users')
            .document(userId)
            .collection('favorite_answers')
            .document(itemId),
      )
      ..delete(
        _firestore
            .collection('answers')
            .document(itemId)
            .collection('favorited_users')
            .document(userId),
      );
    await batch.commit();
  }
}
