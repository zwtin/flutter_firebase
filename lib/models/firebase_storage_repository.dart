import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';
import 'package:flutter_firebase/common/string_extension.dart';

class FirebaseStorageRepository implements StorageRepository {
  FirebaseStorageRepository({FirebaseStorage storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<String> upload(File imageFile) async {
    final imageName = StringExtension.randomString(16);
    final imageData = imageFile.readAsBytesSync();
    final ref = _storage.ref().child('image/$imageName');

    final uploadTask = ref.putData(imageData);
    await uploadTask.onComplete;
    final url = (await ref.getDownloadURL()).toString();
    return url;
  }
}
