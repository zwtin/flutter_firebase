import 'package:flutter_firebase/entities/current_user.dart';

abstract class StorageRepository {
  Future<String> url(String contentName);
}
