import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/blocs/edit_profile/edit_profile_repository.dart';
import 'package:flutter_firebase/blocs/profile/profile_repository.dart';
import 'package:flutter_firebase/models/user.dart';

class FirestoreUserRepository
    implements ProfileRepository, EditProfileRepository {
  FirestoreUserRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  final Firestore _firestore;

  @override
  Stream<User> fetch(String id) {
    return _firestore.collection('user').document(id).snapshots().map(
      (snapshot) {
        return User(
          id: snapshot.documentID,
          name: snapshot.data['name'] as String,
          imageUrl: snapshot.data['image_url'] as String,
          introduction: snapshot.data['introduction'] as String,
        );
      },
    );
  }

  @override
  Future<void> update(String id, User user) async {
    await _firestore
        .collection('user')
        .document(id)
        .updateData(<String, dynamic>{
      'name': user.name,
      'image_url': user.imageUrl,
      'introduction': user.introduction
    });
  }
}
