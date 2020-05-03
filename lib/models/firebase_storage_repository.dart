import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';
import 'package:flutter_firebase/common/string_extension.dart';

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

  Future<String> imageUpload(File imageFile) async {
    final imageName = StringExtension.randomString(16);
    final imageData = imageFile.readAsBytesSync();
    final imageSize = imageData.elementSizeInBytes;
    final uploadTask =
        _storage.ref().child('image/$imageName').putData(imageData);
    await uploadTask.onComplete;
    return imageName;
  }
}
