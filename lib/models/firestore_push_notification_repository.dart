import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/repositories/push_notification_repository.dart';

class FirestorePushNotificationRepository
    implements PushNotificationRepository {
  final _firestore = Firestore.instance;

  @override
  Future<void> registerDeviceToken({
    @required String userId,
    @required String deviceToken,
  }) async {
    await _firestore.runTransaction(
      (transaction) {
        final ref = _firestore
            .collection('users')
            .document(userId)
            .collection('device_token')
            .document();
        final itemMap = {
          'id': ref.documentID,
          'token': deviceToken,
          'register_date': DateTime.now(),
        };
        transaction.set(
          ref,
          itemMap,
        );
        return null;
      },
    );
  }

  @override
  Future<void> unregisterDeviceToken({
    @required String userId,
    @required String deviceToken,
  }) async {
    await _firestore.runTransaction(
      (transaction) async {
        final querySnapshot = await _firestore
            .collection('users')
            .document(userId)
            .collection('device_token')
            .where('token', isEqualTo: deviceToken)
            .getDocuments();
        final doc = querySnapshot.documents.first.reference;
        await transaction.delete(doc);
        return null;
      },
    );
  }
}
