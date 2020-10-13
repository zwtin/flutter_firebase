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
      (transaction) async {
        // deviceTokenがすでに登録済みか調査（登録済みの場合は何もしない）
        final querySnapshot = await _firestore
            .collection('users')
            .document(userId)
            .collection('device_token')
            .where('token', isEqualTo: deviceToken)
            .getDocuments();

        try {
          for (final ref in querySnapshot.documents) {
            final data = await transaction.get(ref.reference);
            if (data.exists) {
              return;
            }
          }
        }
        // エラー時
        on Exception catch (error) {
          print(error.toString());
          return;
        }

        // 登録されていなければ登録
        final ref = _firestore
            .collection('users')
            .document(userId)
            .collection('device_token')
            .document();
        final registerData = {
          'id': ref.documentID,
          'token': deviceToken,
          'register_date': FieldValue.serverTimestamp(),
        };
        await transaction.set(
          ref,
          registerData,
        );
        return;
      },
    );
  }

  @override
  Future<void> unregisterDeviceToken({
    @required String userId,
    @required String deviceToken,
  }) async {
    final batch = _firestore.batch();

    final querySnapshot = await _firestore
        .collection('users')
        .document(userId)
        .collection('device_token')
        .where('token', isEqualTo: deviceToken)
        .getDocuments();
    for (final ref in querySnapshot.documents) {
      batch.delete(ref.reference);
    }

    try {
      await batch.commit();
    }
    // エラー時
    on Exception catch (error) {
      print(error.toString());
      return;
    }
  }
}
