import 'package:flutter_firebase/entities/user.dart';

abstract class ProfileRepository {
  Stream<User> fetch(String id);
}
