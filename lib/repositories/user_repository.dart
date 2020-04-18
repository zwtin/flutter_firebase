import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/user.dart';

abstract class UserRepository {
  Stream<User> getUserStream({@required String userId});
  Future<User> getUser({@required String userId});
  Future<void> createUser({@required String userId});
  Future<void> updateUser({@required String userId, @required User newUser});
  Stream<List<String>> getCreatedItemIds({@required String userId});
  Stream<List<String>> getFavoriteItemIds({@required String userId});
}
