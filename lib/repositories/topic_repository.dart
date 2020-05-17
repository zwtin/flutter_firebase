import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/topic_entity.dart';

abstract class TopicRepository {
  Stream<List<TopicEntity>> getTopicListStream();
  Future<List<TopicEntity>> getTopicList();
  Stream<TopicEntity> getTopicStream({@required String id});
  Future<TopicEntity> getTopic({@required String id});
  Future<void> postTopic(
      {@required String userId, @required TopicEntity topic});
}
