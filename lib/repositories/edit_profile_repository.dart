import 'package:flutter_firebase/entities/user.dart';

abstract class EditProfileRepository {
  Future<void> update(String id, User user);
}
