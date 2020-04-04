import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/entities/item.dart';

abstract class UserRepository {
  Stream<User> getUserDetail({@required String userId});
  Stream<List<String>> getCreatedItemIds({@required String userId});
  Stream<List<String>> getFavoriteItemIds({@required String userId});
}
