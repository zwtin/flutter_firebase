import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/entities/topic_entity.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';

class FirestoreTopicRepository implements TopicRepository {
  final _firestore = Firestore.instance;

  @override
  Stream<List<TopicEntity>> getTopicListStream() {
    return _firestore.collection('topics').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.documents.map(
          (DocumentSnapshot docs) {
            return TopicEntity(
              id: docs.data['id'] as String,
              text: docs.data['text'] as String,
              imageUrl: docs.data['image_url'] as String,
              createdAt: docs.data['created_at'].toDate() as DateTime,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
  }

  @override
  Future<List<TopicEntity>> getTopicList() async {
    final list = await _firestore.collection('topics').getDocuments().then(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.documents.map(
          (DocumentSnapshot docs) {
            return TopicEntity(
              id: docs.data['id'] as String,
              text: docs.data['text'] as String,
              imageUrl: docs.data['image_url'] as String,
              createdAt: docs.data['created_at'].toDate() as DateTime,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
    return list;
  }

  @override
  Stream<TopicEntity> getTopic({@required String id}) {
    return _firestore.collection('topics').document(id).snapshots().map(
      (DocumentSnapshot snapshot) {
        return TopicEntity(
          id: snapshot.data['id'] as String,
          text: snapshot.data['text'] as String,
          imageUrl: snapshot.data['image_url'] as String,
          createdAt: snapshot.data['created_at'].toDate() as DateTime,
          createdUser: snapshot.data['created_user'] as String,
        );
      },
    );
  }

  @override
  Future<void> postTopic(
      {@required String userId, @required TopicEntity topic}) async {
    await _firestore.runTransaction(
      (transaction) {
        final ref = _firestore.collection('topics').document();
        final topicMap = {
          'id': ref.documentID,
          'text': topic.text,
          'image_url': topic.imageUrl,
          'created_at': topic.createdAt,
          'created_user': topic.createdUser,
        };
        transaction.set(
          ref,
          topicMap,
        );
        final userMap = {'id': ref.documentID};
        transaction.set(
            _firestore
                .collection('users')
                .document(userId)
                .collection('create_topics')
                .document(ref.documentID),
            userMap);
        return null;
      },
    );
  }
}
