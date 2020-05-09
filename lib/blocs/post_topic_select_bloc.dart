import 'package:flutter_firebase/entities/topic.dart';
import 'package:flutter_firebase/repositories/topic_repository.dart';
import 'package:rxdart/rxdart.dart';

class PostTopicSelectBloc {
  PostTopicSelectBloc(this._topicRepository)
      : assert(_topicRepository != null) {
    start();
  }

  final TopicRepository _topicRepository;

  final BehaviorSubject<List<Topic>> topicController =
      BehaviorSubject<List<Topic>>.seeded([]);

  Future<void> start() async {
    try {
      final topics = await _topicRepository.getTopicList();
      topicController.sink.add(topics);
    } on Exception catch (error) {
      return;
    }
  }

  Future<void> dispose() async {
    await topicController.close();
  }
}
