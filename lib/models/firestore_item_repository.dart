import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/repositories/item_repository.dart';

class FirestoreItemRepository implements ItemRepository {
  final _firestore = Firestore.instance;

  @override
  Stream<List<Item>> getItemListStream() {
    return _firestore.collection('items').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.documents.map(
          (DocumentSnapshot docs) {
            return Item(
              id: docs.data['id'] as String,
              title: docs.data['title'] as String,
              description: docs.data['description'] as String,
              date: docs.data['date']?.toDate() as DateTime,
              imageUrl: docs.data['image_url'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
  }

  @override
  Future<List<Item>> getItemList() async {
    final list = await _firestore.collection('items').getDocuments().then(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.documents.map(
          (DocumentSnapshot docs) {
            return Item(
              id: docs.data['id'] as String,
              title: docs.data['title'] as String,
              description: docs.data['description'] as String,
              date: docs.data['date']?.toDate() as DateTime,
              imageUrl: docs.data['image_url'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
    return list;
  }

  @override
  Stream<Item> getItemDetail({@required String id}) {
    return _firestore.collection('items').document(id).snapshots().map(
      (DocumentSnapshot snapshot) {
        return Item(
          id: snapshot.data['id'] as String,
          title: snapshot.data['title'] as String,
          description: snapshot.data['description'] as String,
          date: snapshot.data['date']?.toDate() as DateTime,
          imageUrl: snapshot.data['image_url'] as String,
          createdUser: snapshot.data['created_user'] as String,
        );
      },
    );
  }

  @override
  Stream<List<Item>> getSelectedItemListStream({@required List<String> ids}) {
    return _firestore
        .collection('items')
        .where('id', whereIn: ids)
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        return snapshot.documents.map(
          (DocumentSnapshot docs) {
            return Item(
              id: docs.data['id'] as String,
              title: docs.data['title'] as String,
              description: docs.data['description'] as String,
              date: docs.data['date']?.toDate() as DateTime,
              imageUrl: docs.data['image_url'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> postItem({@required String userId, @required Item item}) async {
    await _firestore.runTransaction(
      (transaction) {
        final ref = _firestore.collection('items').document();
        final itemMap = {
          'id': ref.documentID,
          'title': item.title,
          'description': item.description,
          'image_url': item.imageUrl,
          'created_user': userId,
          'date': item.date,
        };
        transaction.set(
          ref,
          itemMap,
        );
        final userMap = {'id': ref.documentID};
        transaction.set(
            _firestore
                .collection('users')
                .document(userId)
                .collection('create_items')
                .document(ref.documentID),
            userMap);
        return null;
      },
    );
  }
}
