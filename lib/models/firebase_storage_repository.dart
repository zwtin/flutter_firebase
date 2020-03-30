import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';

class FirebaseStorageRepository extends StorageRepository {
  FirebaseStorageRepository({FirebaseStorage storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<String> url(String contentName) async {
    final dynamic url =
        await _storage.ref().child(contentName).getDownloadURL();
    return url.toString();
  }
}
