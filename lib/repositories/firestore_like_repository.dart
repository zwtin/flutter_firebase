import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreLikeRepository {
  FirestoreLikeRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  final Firestore _firestore;

  Future<void> like({String userId, String itemId}) async {
    final batch = _firestore.batch();
    final map = {'id': itemId};
    batch.setData(
      _firestore
          .collection('users')
          .document(userId)
          .collection('like_items')
          .document(itemId),
      map,
    );
    await batch.commit();
  }
}
