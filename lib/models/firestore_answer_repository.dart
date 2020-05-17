import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/entities/answer_entity.dart';
import 'package:flutter_firebase/repositories/answer_repository.dart';

class FirestoreAnswerRepository implements AnswerRepository {
  final _firestore = Firestore.instance;

  @override
  Stream<List<AnswerEntity>> getAnswerListStream() {
    return _firestore.collection('answers').snapshots().map(
      (QuerySnapshot snapshot) {
        return snapshot.documents.map(
          (DocumentSnapshot docs) {
            return AnswerEntity(
              id: docs.data['id'] as String,
              text: docs.data['text'] as String,
              createdAt: docs.data['created_at']?.toDate() as DateTime,
              rank: docs.data['rank'] as int,
              topicId: docs.data['topicId'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
  }

  @override
  Future<List<AnswerEntity>> getAnswerList() async {
    final list = await _firestore.collection('answers').getDocuments().then(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.documents.map(
          (DocumentSnapshot docs) {
            return AnswerEntity(
              id: docs.data['id'] as String,
              text: docs.data['text'] as String,
              createdAt: docs.data['created_at']?.toDate() as DateTime,
              rank: docs.data['rank'] as int,
              topicId: docs.data['topicId'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
    return list;
  }

  @override
  Future<List<AnswerEntity>> getNewAnswerList(AnswerEntity answerEntity) async {
    if (answerEntity != null) {
      final list = await _firestore
          .collection('answers')
          .where('created_at', isGreaterThan: answerEntity.createdAt)
          .orderBy('created_at', descending: true)
          .limit(20)
          .getDocuments()
          .then(
        (QuerySnapshot querySnapshot) {
          return querySnapshot.documents.map(
            (DocumentSnapshot docs) {
              return AnswerEntity(
                id: docs.data['id'] as String,
                text: docs.data['text'] as String,
                createdAt: docs.data['created_at']?.toDate() as DateTime,
                rank: docs.data['rank'] as int,
                topicId: docs.data['topicId'] as String,
                createdUser: docs.data['created_user'] as String,
              );
            },
          ).toList();
        },
      );
      return list;
    }
    final list = await _firestore
        .collection('answers')
        .orderBy('created_at', descending: true)
        .limit(20)
        .getDocuments()
        .then(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.documents.map(
          (DocumentSnapshot docs) {
            return AnswerEntity(
              id: docs.data['id'] as String,
              text: docs.data['text'] as String,
              createdAt: docs.data['created_at']?.toDate() as DateTime,
              rank: docs.data['rank'] as int,
              topicId: docs.data['topicId'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
    return list;
  }

  @override
  Future<List<AnswerEntity>> getPopularAnswerList(
      AnswerEntity answerEntity) async {
    if (answerEntity != null) {
      final list = await _firestore
          .collection('answers')
          .where('rank', isGreaterThan: answerEntity.rank)
          .orderBy('rank')
          .limit(20)
          .getDocuments()
          .then(
        (QuerySnapshot querySnapshot) {
          return querySnapshot.documents.map(
            (DocumentSnapshot docs) {
              return AnswerEntity(
                id: docs.data['id'] as String,
                text: docs.data['text'] as String,
                createdAt: docs.data['created_at']?.toDate() as DateTime,
                rank: docs.data['rank'] as int,
                topicId: docs.data['topicId'] as String,
                createdUser: docs.data['created_user'] as String,
              );
            },
          ).toList();
        },
      );
      return list;
    }
    final list = await _firestore
        .collection('answers')
        .orderBy('rank')
        .limit(20)
        .getDocuments()
        .then(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.documents.map(
          (DocumentSnapshot docs) {
            return AnswerEntity(
              id: docs.data['id'] as String,
              text: docs.data['text'] as String,
              createdAt: docs.data['created_at']?.toDate() as DateTime,
              rank: docs.data['rank'] as int,
              topicId: docs.data['topicId'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
    return list;
  }

  @override
  Stream<AnswerEntity> getAnswerStream({@required String id}) {
    return _firestore.collection('answers').document(id).snapshots().map(
      (DocumentSnapshot snapshot) {
        return AnswerEntity(
          id: snapshot.data['id'] as String,
          text: snapshot.data['text'] as String,
          createdAt: snapshot.data['created_at']?.toDate() as DateTime,
          rank: snapshot.data['rank'] as int,
          topicId: snapshot.data['topicId'] as String,
          createdUser: snapshot.data['created_user'] as String,
        );
      },
    );
  }

  @override
  Future<AnswerEntity> getAnswer({@required String id}) {
    return _firestore.collection('answers').document(id).get().then(
      (DocumentSnapshot snapshot) {
        return AnswerEntity(
          id: snapshot.data['id'] as String,
          text: snapshot.data['text'] as String,
          createdAt: snapshot.data['created_at']?.toDate() as DateTime,
          rank: snapshot.data['rank'] as int,
          topicId: snapshot.data['topicId'] as String,
          createdUser: snapshot.data['created_user'] as String,
        );
      },
    );
  }

  @override
  Stream<List<AnswerEntity>> getSelectedAnswerListStream(
      {@required List<String> ids}) {
    return _firestore
        .collection('answers')
        .where('id', whereIn: ids)
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        return snapshot.documents.map(
          (DocumentSnapshot docs) {
            return AnswerEntity(
              id: docs.data['id'] as String,
              text: docs.data['text'] as String,
              createdAt: docs.data['created_at']?.toDate() as DateTime,
              rank: docs.data['rank'] as int,
              topicId: docs.data['topicId'] as String,
              createdUser: docs.data['created_user'] as String,
            );
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> postAnswer(
      {@required String userId, @required AnswerEntity answerEntity}) async {
    final exist = await _firestore
        .collection('topic_answered_time')
        .document(answerEntity.topicId)
        .get()
        .then(
      (DocumentSnapshot snapshot) {
        return snapshot.exists;
      },
    );
    if (exist) {
      await _firestore.runTransaction(
        (transaction) {
          final ref = _firestore.collection('answers').document();
          final itemMap = {
            'id': ref.documentID,
            'text': answerEntity.text,
            'topicId': answerEntity.topicId,
            'rank': answerEntity.rank,
            'created_at': FieldValue.serverTimestamp(),
            'created_user': answerEntity.createdUser,
          };
          transaction.set(
            ref,
            itemMap,
          );
          final timeMap = {
            'id': answerEntity.topicId,
            'time': FieldValue.increment(1),
          };
          transaction.update(
              _firestore
                  .collection('topic_answered_time')
                  .document(answerEntity.topicId),
              timeMap);
          final userMap = {'id': ref.documentID};
          transaction.set(
              _firestore
                  .collection('users')
                  .document(userId)
                  .collection('create_answers')
                  .document(ref.documentID),
              userMap);
          return null;
        },
      );
    } else {
      await _firestore.runTransaction(
        (transaction) {
          final ref = _firestore.collection('answers').document();
          final itemMap = {
            'id': ref.documentID,
            'text': answerEntity.text,
            'topicId': answerEntity.topicId,
            'rank': answerEntity.rank,
            'created_at': FieldValue.serverTimestamp(),
            'created_user': answerEntity.createdUser,
          };
          transaction.set(
            ref,
            itemMap,
          );
          final timeMap = {
            'id': answerEntity.topicId,
            'time': FieldValue.increment(1),
          };
          transaction.set(
              _firestore
                  .collection('topic_answered_time')
                  .document(answerEntity.topicId),
              timeMap);
          final userMap = {'id': ref.documentID};
          transaction.set(
              _firestore
                  .collection('users')
                  .document(userId)
                  .collection('create_answers')
                  .document(ref.documentID),
              userMap);
          return null;
        },
      );
    }
  }
}
