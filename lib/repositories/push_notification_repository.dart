import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/user.dart';

abstract class PushNotificationRepository {
  Future<void> registerDeviceToken({
    @required String userId,
    @required String deviceToken,
  });
  Future<void> unregisterDeviceToken({
    @required String userId,
    @required String deviceToken,
  });
}
