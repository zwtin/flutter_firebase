import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/entities/parameters/get_new_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/parameters/get_popular_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/parameters/get_user_create_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/responses/get_new_answer_list_response.dart';
import 'package:flutter_firebase/entities/responses/get_popular_answer_list_response.dart';
import 'package:flutter_firebase/entities/responses/get_user_create_answer_list_response.dart';
import 'package:flutter_firebase/entities/responses/get_user_favor_answer_list_response.dart';
import 'package:flutter_firebase/entities/parameters/get_user_favor_answer_list_parameter.dart';
import 'package:flutter_firebase/use_cases/answer_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/responses/get_answer_response.dart';
import 'package:flutter_firebase/entities/parameters/get_answer_parameter.dart';
import 'package:flutter_firebase/repositories/sample_repository.dart';

class FirestoreSampleRepository implements SampleRepository {
  final _firestore = Firestore.instance;

  // idの回答を返す
  @override
  Future<GetAnswerResponse> getAnswer(
      {@required GetAnswerParameter parameter}) async {
    assert(parameter != null);
    return _firestore.collection('answers').document(parameter.id).get().then(
      (DocumentSnapshot snapshot) {
        return GetAnswerResponse(
          answer: AnswerEntity(
            id: snapshot.data['id'] as String,
            text: snapshot.data['text'] as String,
            createdAt: snapshot.data['created_at'].toDate() as DateTime,
            rank: snapshot.data['rank'] as int,
            topicId: snapshot.data['topicId'] as String,
            createdUser: snapshot.data['created_user'] as String,
          ),
        );
      },
    );
  }

  // createdAtより古い回答を10個返す
  @override
  Future<GetNewAnswerListResponse> getNewAnswerList(
      {@required GetNewAnswerListParameter parameter}) async {
    assert(parameter != null);
    return _firestore
        .collection('answers')
        .where(
          'created_at',
          isLessThan: parameter.createdAt != null
              ? parameter.createdAt.add(const Duration(milliseconds: -1))
              : DateTime.now(),
        )
        .orderBy('created_at', descending: true)
        .limit(11)
        .getDocuments()
        .then(
      (QuerySnapshot querySnapshot) {
        var list = querySnapshot.documents.map(
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

        final hasNext = querySnapshot.documents.length > 10;

        if (hasNext) {
          // 11個取得できた時は、最後の要素を削除
          list.removeLast();
        }
        return GetNewAnswerListResponse(
          answers: list,
          hasNext: hasNext,
        );
      },
    );
  }

  // rankより低い回答を10個返す
  @override
  Future<GetPopularAnswerListResponse> getPopularAnswerList(
      {@required GetPopularAnswerListParameter parameter}) async {
    assert(parameter != null);
    return _firestore
        .collection('answers')
        .where(
          'rank',
          isLessThan: parameter.rank != null ? parameter.rank : 1000,
        )
        .orderBy('rank', descending: true)
        .limit(11)
        .getDocuments()
        .then(
      (QuerySnapshot querySnapshot) {
        var list = querySnapshot.documents.map(
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

        final hasNext = querySnapshot.documents.length > 10;

        if (hasNext) {
          // 11個取得できた時は、最後の要素を削除
          list.removeLast();
        }
        return GetPopularAnswerListResponse(
          answers: list,
          hasNext: hasNext,
        );
      },
    );
  }

  // userIdが生成した回答で、createdAtより古い回答を10個返す
  @override
  Future<GetUserCreateAnswerListResponse> getUserCreateAnswerList(
      {@required GetUserCreateAnswerListParameter parameter}) async {
    assert(parameter != null);
    return _firestore
        .collection('users')
        .document(parameter.userId)
        .collection('create_answers')
        .where(
          'created_at',
          isLessThan: parameter.createdAt != null
              ? parameter.createdAt.add(const Duration(milliseconds: -1))
              : DateTime.now(),
        )
        .orderBy('created_at', descending: true)
        .limit(11)
        .getDocuments()
        .then(
      (QuerySnapshot querySnapshot) {
        var list = querySnapshot.documents.map(
          (DocumentSnapshot docs) {
            return AnswerEntity(
              id: docs.data['id'] as String,
              createdAt: docs.data['created_at'].toDate() as DateTime,
            );
          },
        ).toList();

        final hasNext = querySnapshot.documents.length > 10;

        if (hasNext) {
          // 11個取得できた時は、最後の要素を削除
          list.removeLast();
        }
        return GetUserCreateAnswerListResponse(
          answers: list,
          hasNext: hasNext,
        );
      },
    );
  }

  // userIdがお気に入りした回答で、favorAtより古い回答を10個返す
  @override
  Future<GetUserFavorAnswerListResponse> getUserFavorAnswerList(
      {@required GetUserFavorAnswerListParameter parameter}) async {
    assert(parameter != null);
    return _firestore
        .collection('users')
        .document(parameter.userId)
        .collection('favorite_answers')
        .where(
          'favor_at',
          isLessThan: parameter.favorAt != null
              ? parameter.favorAt.add(const Duration(milliseconds: -1))
              : DateTime.now(),
        )
        .orderBy('favor_at', descending: true)
        .limit(11)
        .getDocuments()
        .then(
      (QuerySnapshot querySnapshot) {
        var list = querySnapshot.documents.map(
          (DocumentSnapshot docs) {
            return AnswerEntity(
              id: docs.data['id'] as String,
              createdAt: docs.data['favor_at'].toDate() as DateTime,
            );
          },
        ).toList();

        final hasNext = querySnapshot.documents.length > 10;

        if (hasNext) {
          // 11個取得できた時は、最後の要素を削除
          list.removeLast();
        }
        return GetUserFavorAnswerListResponse(
          answers: list,
          hasNext: hasNext,
        );
      },
    );
  }
}
