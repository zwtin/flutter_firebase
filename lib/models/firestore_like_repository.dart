import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/repositories/like_repository.dart';

class FirestoreLikeRepository implements LikeRepository {
  FirestoreLikeRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  final Firestore _firestore;

  @override
  Future<void> like({String userId, String itemId}) async {
    final isOwnLike = await _firestore
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

    final isLikedFromMe = await _firestore
        .collection('items')
        .document(itemId)
        .collection('liked_users')
        .document(userId)
        .get()
        .then(
      (document) {
        return document.exists;
      },
    );

    if (isOwnLike && isLikedFromMe) {
      final batch = _firestore.batch();
      batch.delete(
        _firestore
            .collection('users')
            .document(userId)
            .collection('like_items')
            .document(itemId),
      );
      batch.delete(
        _firestore
            .collection('items')
            .document(itemId)
            .collection('liked_users')
            .document(userId),
      );
      await batch.commit();
    } else if (!isOwnLike && !isLikedFromMe) {
      final batch = _firestore.batch();
      final itemMap = {'id': itemId};
      batch.setData(
        _firestore
            .collection('users')
            .document(userId)
            .collection('like_items')
            .document(itemId),
        itemMap,
      );
      final userMap = {'id': userId};
      batch.setData(
        _firestore
            .collection('items')
            .document(itemId)
            .collection('liked_users')
            .document(userId),
        userMap,
      );
      await batch.commit();
    }
  }
}
