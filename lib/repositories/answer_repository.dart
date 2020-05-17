import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/answer_entity.dart';

abstract class AnswerRepository {
  Stream<List<AnswerEntity>> getAnswerListStream();
  Future<List<AnswerEntity>> getAnswerList();
  Future<List<AnswerEntity>> getNewAnswerList(AnswerEntity answerEntity);
  Future<List<AnswerEntity>> getPopularAnswerList(AnswerEntity answerEntity);
  Stream<AnswerEntity> getAnswerStream({@required String id});
  Future<AnswerEntity> getAnswer({@required String id});
  Stream<List<AnswerEntity>> getSelectedAnswerListStream(
      {@required List<String> ids});
  Future<void> postAnswer(
      {@required String userId, @required AnswerEntity answerEntity});
}
