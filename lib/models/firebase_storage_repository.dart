import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';
import 'package:flutter_firebase/common/string_extension.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FirebaseStorageRepository implements StorageRepository {
  FirebaseStorageRepository({FirebaseStorage storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<String> upload(File imageFile) async {
    final imageName = StringExtension.randomString(16);

    final result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minHeight: 500,
      minWidth: 500,
      quality: 85,
    );

    final ref = _storage.ref().child('image/$imageName');

    final metaData = StorageMetadata(contentType: 'image/jpeg');
    final uploadTask = ref.putData(result, metaData);
    await uploadTask.onComplete;
    final url = (await ref.getDownloadURL()).toString();
    return url;
  }
}
