import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/entities/user.dart';
import 'package:flutter_firebase/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreUserRepository implements UserRepository {
  final _firestore = Firestore.instance;

  @override
  Stream<User> getUserDetail({@required String userId}) {
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

//  @override
//  Future<void> update(String id, User user) async {
//    await _firestore
//        .collection('user')
//        .document(id)
//        .updateData(<String, dynamic>{
//      'name': user.name,
//      'image_url': user.imageUrl,
//      'introduction': user.introduction
//    });
//  }
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
