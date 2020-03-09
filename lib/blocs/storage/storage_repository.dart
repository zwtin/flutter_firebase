import 'package:flutter_firebase/models/current_user.dart';

abstract class StorageRepository {
  Future<String> url(String contentName);
}
