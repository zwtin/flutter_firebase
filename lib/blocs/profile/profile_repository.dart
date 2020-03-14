import 'package:flutter_firebase/models/user.dart';

abstract class ProfileRepository {
  Stream<User> fetch(String id);
}
