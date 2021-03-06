import 'package:flutter/material.dart';
import 'package:flutter_firebase/use_cases/create_answer_entity.dart';
import 'package:flutter_firebase/use_cases/favorite_answer_entity.dart';
import 'package:flutter_firebase/use_cases/user.dart';

abstract class UserRepository {
  Stream<User> getUserStream({@required String userId});
  Future<User> getUser({@required String userId});
  Future<bool> isExistUser({@required String userId});
  Future<void> createUser({@required String userId});
  Future<void> updateUser({@required String userId, @required User user});
  Stream<List<CreateAnswerEntity>> getCreateAnswersStream(
      {@required String userId});
  Stream<List<FavoriteAnswerEntity>> getFavoriteAnswersStream(
      {@required String userId});
}
