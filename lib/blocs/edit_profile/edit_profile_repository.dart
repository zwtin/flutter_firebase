import 'package:flutter_firebase/models/user.dart';

abstract class EditProfileRepository {
  Future<void> update(String id, User user);
}
