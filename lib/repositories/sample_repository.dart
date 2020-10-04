import 'package:flutter_firebase/entities/parameters/get_new_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/parameters/get_popular_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/parameters/get_user_create_answer_list_parameter.dart';
import 'package:flutter_firebase/entities/responses/get_new_answer_list_response.dart';
import 'package:flutter_firebase/entities/responses/get_popular_answer_list_response.dart';
import 'package:flutter_firebase/entities/responses/get_user_create_answer_list_response.dart';
import 'package:flutter_firebase/entities/responses/get_user_favor_answer_list_response.dart';
import 'package:flutter_firebase/entities/parameters/get_user_favor_answer_list_parameter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/responses/get_answer_response.dart';
import 'package:flutter_firebase/entities/parameters/get_answer_parameter.dart';

abstract class SampleRepository {
  // idの回答を返す
  Future<GetAnswerResponse> getAnswer({@required GetAnswerParameter parameter});

  // createdAtより古い回答を10個返す
  Future<GetNewAnswerListResponse> getNewAnswerList(
      {@required GetNewAnswerListParameter parameter});

  // rankより低い回答を10個返す
  Future<GetPopularAnswerListResponse> getPopularAnswerList(
      {@required GetPopularAnswerListParameter parameter});

  // userIdが生成した回答で、createdAtより古い回答を10個返す
  Future<GetUserCreateAnswerListResponse> getUserCreateAnswerList(
      {@required GetUserCreateAnswerListParameter parameter});

  // userIdがお気に入りした回答で、favorAtより古い回答を10個返す
  Future<GetUserFavorAnswerListResponse> getUserFavorAnswerList(
      {@required GetUserFavorAnswerListParameter parameter});
}
