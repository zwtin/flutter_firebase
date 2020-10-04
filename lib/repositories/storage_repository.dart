import 'dart:io';
import 'package:flutter_firebase/use_cases/current_user.dart';

abstract class StorageRepository {
  Future<String> upload(File imageFile);
}
