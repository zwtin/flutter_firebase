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
    await _firestore
        .collection('users')
        .document(userId)
        .collection('device_token')
        .document()
        .setData(
      <String, dynamic>{
        'id': FieldPath.documentId,
        'token': deviceToken,
        'register_date': DateTime.now(),
      },
    );
  }

  @override
  Future<void> unregisterDeviceToken({
    @required String userId,
    @required String deviceToken,
  }) async {
    await _firestore
        .collection('users')
        .document(userId)
        .collection('device_token')
        .where('token', isEqualTo: deviceToken)
        .getDocuments()
        .then(
      (QuerySnapshot querySnapshot) {
        for (final doc in querySnapshot.documents) {
          doc.reference.delete();
        }
      },
    );
  }
}
