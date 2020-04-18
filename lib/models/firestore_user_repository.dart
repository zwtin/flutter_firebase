import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';

class FirestoreUserRepository implements UserRepository {
  final _firestore = Firestore.instance;

  @override
  Stream<User> getUserStream({@required String userId}) {
    return _firestore.collection('users').document(userId).snapshots().map(
      (DocumentSnapshot snapshot) {
        return User(
          id: snapshot.data['id'] as String,
          name: snapshot.data['name'] as String,
          imageUrl: snapshot.data['image_url'] as String,
          introduction: snapshot.data['introduction'] as String,
        );
      },
    );
  }

  @override
  Future<User> getUser({@required String userId}) async {
    final user =
        await _firestore.collection('users').document(userId).get().then(
      (DocumentSnapshot snapshot) {
        return User(
          id: snapshot.data['id'] as String,
          name: snapshot.data['name'] as String,
          imageUrl: snapshot.data['image_url'] as String,
          introduction: snapshot.data['introduction'] as String,
        );
      },
    );
    return user;
  }

  @override
  Future<void> createUser({@required String userId}) async {
    await _firestore.collection('users').document(userId).setData(
      <String, dynamic>{
        'id': userId,
        'introduction': 'よろしくお願いします。',
        'name': '名無し',
        'image_url': 'TsHfWXZ2p1uOtRTP',
      },
    );
  }

  @override
  Future<void> updateUser(
      {@required String userId, @required User newUser}) async {
    await _firestore.collection('users').document(userId).updateData(
      <String, dynamic>{
        'name': newUser.name,
        'image_url': newUser.imageUrl,
        'introduction': newUser.introduction
      },
    );
  }

  @override
  Stream<List<String>> getCreatedItemIds({@required String userId}) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection('create_items')
        .snapshots()
        .map(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.documents.map(
          (DocumentSnapshot documentSnapshot) {
            return documentSnapshot.data['id'] as String;
          },
        ).toList();
      },
    );
  }

  @override
  Stream<List<String>> getFavoriteItemIds({@required String userId}) {
    return _firestore
        .collection('users')
        .document(userId)
        .collection('favorite_items')
        .snapshots()
        .map(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.documents.map(
          (DocumentSnapshot documentSnapshot) {
            return documentSnapshot.data['id'] as String;
          },
        ).toList();
      },
    );
  }
}
