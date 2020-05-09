import 'package:flutter/material.dart';
import 'package:flutter_firebase/entities/topic.dart';

abstract class TopicRepository {
  Stream<List<Topic>> getTopicListStream();
  Future<List<Topic>> getTopicList();
  Stream<Topic> getTopic({@required String id});
  Future<void> postTopic({@required String userId, @required Topic topic});
}
